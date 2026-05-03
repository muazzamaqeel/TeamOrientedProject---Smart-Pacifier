#!/usr/bin/env python3
import os
import platform
import subprocess
import sys


CONTAINER_NAME = "mosquitto-broker"
IMAGE_NAME = "eclipse-mosquitto:latest"

# This must match your ESP32 C code:
# static const char *BROKER_URI = "mqtt://192.168.0.100:1883";
BROKER_IP = "192.168.0.101"

MQTT_PORT = "1883"
WEBSOCKET_PORT = "9001"


def run_command(command, check=True, shell=False):
    if isinstance(command, list):
        print(f"\n>>> {' '.join(command)}\n")
    else:
        print(f"\n>>> {command}\n")

    result = subprocess.run(command, shell=shell)

    if check and result.returncode != 0:
        print(f"[ERROR] Command failed with exit code {result.returncode}")
        sys.exit(result.returncode)

    return result.returncode


def capture_command(command, shell=False):
    result = subprocess.run(
        command,
        shell=shell,
        capture_output=True,
        text=True
    )
    return result.stdout.strip()


def docker_exists():
    result = subprocess.run(
        ["docker", "--version"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )
    return result.returncode == 0


def container_exists():
    result = subprocess.run(
        ["docker", "ps", "-a", "--format", "{{.Names}}"],
        capture_output=True,
        text=True
    )
    return CONTAINER_NAME in result.stdout.splitlines()


def container_running():
    result = subprocess.run(
        ["docker", "ps", "--format", "{{.Names}}"],
        capture_output=True,
        text=True
    )
    return CONTAINER_NAME in result.stdout.splitlines()


def broker_ip_exists():
    system_name = platform.system()

    if system_name == "Linux":
        output = capture_command(["ip", "addr"])
        return BROKER_IP in output

    if system_name == "Darwin":
        output = capture_command(["ifconfig"])
        return BROKER_IP in output

    if system_name == "Windows":
        output = capture_command([
            "powershell",
            "-NoProfile",
            "-Command",
            f"Get-NetIPAddress -AddressFamily IPv4 -IPAddress {BROKER_IP} -ErrorAction SilentlyContinue"
        ])
        return BROKER_IP in output

    return False


def get_linux_default_interface():
    return capture_command([
        "bash",
        "-c",
        "ip route | awk '/default/ {print $5; exit}'"
    ])


def get_macos_default_interface():
    return capture_command([
        "bash",
        "-c",
        "route get default 2>/dev/null | awk '/interface:/ {print $2}'"
    ])


def get_windows_default_interface():
    return capture_command([
        "powershell",
        "-NoProfile",
        "-Command",
        "Get-NetRoute -DestinationPrefix '0.0.0.0/0' | "
        "Sort-Object RouteMetric | "
        "Select-Object -First 1 -ExpandProperty InterfaceAlias"
    ])


def add_fixed_broker_ip():
    if broker_ip_exists():
        print(f"[OK] Fixed broker IP already exists: {BROKER_IP}")
        return

    system_name = platform.system()
    print(f"[INFO] Adding fixed broker IP: {BROKER_IP}")

    if system_name == "Linux":
        iface = get_linux_default_interface()

        if not iface:
            print("[ERROR] Could not detect Linux network interface.")
            sys.exit(1)

        run_command([
            "sudo",
            "ip",
            "addr",
            "add",
            f"{BROKER_IP}/24",
            "dev",
            iface
        ])

        print(f"[OK] Added {BROKER_IP} to Linux interface: {iface}")
        return

    if system_name == "Darwin":
        iface = get_macos_default_interface()

        if not iface:
            print("[ERROR] Could not detect macOS network interface.")
            sys.exit(1)

        run_command([
            "sudo",
            "ifconfig",
            iface,
            "alias",
            BROKER_IP,
            "255.255.255.0"
        ])

        print(f"[OK] Added {BROKER_IP} to macOS interface: {iface}")
        return

    if system_name == "Windows":
        iface = get_windows_default_interface()

        if not iface:
            print("[ERROR] Could not detect Windows network interface.")
            sys.exit(1)

        print("[INFO] On Windows, run this script as Administrator.")

        run_command([
            "netsh",
            "interface",
            "ipv4",
            "add",
            "address",
            f"name={iface}",
            f"address={BROKER_IP}",
            "mask=255.255.255.0"
        ])

        print(f"[OK] Added {BROKER_IP} to Windows interface: {iface}")
        return

    print(f"[ERROR] Unsupported OS: {system_name}")
    sys.exit(1)


def create_mosquitto_config():
    base_dir = os.path.dirname(os.path.abspath(__file__))

    config_dir = os.path.join(base_dir, "mosquitto_config")
    data_dir = os.path.join(base_dir, "mosquitto_data")
    log_dir = os.path.join(base_dir, "mosquitto_log")

    os.makedirs(config_dir, exist_ok=True)
    os.makedirs(data_dir, exist_ok=True)
    os.makedirs(log_dir, exist_ok=True)

    config_path = os.path.join(config_dir, "mosquitto.conf")

    config_content = f"""listener {MQTT_PORT}
allow_anonymous true

listener {WEBSOCKET_PORT}
protocol websockets

persistence true
persistence_location /mosquitto/data/

log_dest stdout
log_dest file /mosquitto/log/mosquitto.log
"""

    with open(config_path, "w", encoding="utf-8") as file:
        file.write(config_content)

    return config_dir, data_dir, log_dir


def remove_container_if_exists():
    if container_running():
        run_command(["docker", "stop", CONTAINER_NAME])

    if container_exists():
        run_command(["docker", "rm", CONTAINER_NAME])


def start_broker():
    if not docker_exists():
        print("[ERROR] Docker is not installed or not available in PATH.")
        print("Linux: install Docker Engine.")
        print("Windows/macOS: install and start Docker Desktop.")
        sys.exit(1)

    system_name = platform.system()
    print(f"[INFO] Detected OS: {system_name}")

    add_fixed_broker_ip()

    config_dir, data_dir, log_dir = create_mosquitto_config()

    # Important:
    # Always recreate container so Docker uses the correct IP binding:
    # 192.168.0.100:1883 -> container 1883
    if container_exists():
        print("[INFO] Existing broker container found. Recreating it with fixed IP mapping...")
        remove_container_if_exists()

    print("[INFO] Pulling Mosquitto Docker image...")
    run_command(["docker", "pull", IMAGE_NAME])

    print("[INFO] Creating and starting Mosquitto broker...")

    run_command([
        "docker", "run",
        "-d",
        "--name", CONTAINER_NAME,

        # Bind Docker only to the fixed broker IP.
        # This is the important line for your ESP32.
        "-p", f"{BROKER_IP}:{MQTT_PORT}:{MQTT_PORT}",
        "-p", f"{BROKER_IP}:{WEBSOCKET_PORT}:{WEBSOCKET_PORT}",

        "-v", f"{config_dir}:/mosquitto/config",
        "-v", f"{data_dir}:/mosquitto/data",
        "-v", f"{log_dir}:/mosquitto/log",

        IMAGE_NAME,
        "mosquitto",
        "-c", "/mosquitto/config/mosquitto.conf"
    ])

    print("\n[OK] MQTT broker is running.")
    print(f"[OK] ESP32 broker URI: mqtt://{BROKER_IP}:{MQTT_PORT}")
    print(f"[INFO] MQTT TCP port: {MQTT_PORT}")
    print(f"[INFO] WebSocket port: {WEBSOCKET_PORT}")
    print(f"[INFO] Container name: {CONTAINER_NAME}")

    print("\n[INFO] Docker port mapping:")
    run_command(["docker", "ps", "--filter", f"name={CONTAINER_NAME}"], check=False)


def stop_broker():
    if container_running():
        run_command(["docker", "stop", CONTAINER_NAME])
        print("[OK] MQTT broker stopped.")
    else:
        print("[INFO] MQTT broker is not running.")


def restart_broker():
    stop_broker()
    start_broker()


def logs():
    if container_exists():
        run_command(["docker", "logs", "-f", CONTAINER_NAME], check=False)
    else:
        print("[ERROR] MQTT broker container does not exist yet.")


def status():
    print("[INFO] Docker container status:")
    run_command(["docker", "ps", "-a", "--filter", f"name={CONTAINER_NAME}"], check=False)

    print("\n[INFO] Fixed broker IP status:")
    if broker_ip_exists():
        print(f"[OK] Fixed broker IP is active: {BROKER_IP}")
    else:
        print(f"[WARNING] Fixed broker IP is not active: {BROKER_IP}")

    print(f"\n[INFO] ESP32 broker URI: mqtt://{BROKER_IP}:{MQTT_PORT}")

    system_name = platform.system()

    if system_name == "Linux":
        print("\n[INFO] Listening sockets on port 1883:")
        run_command(["bash", "-c", "ss -ltnp | grep ':1883' || true"], check=False)

    if system_name == "Darwin":
        print("\n[INFO] Listening sockets on port 1883:")
        run_command(["bash", "-c", "lsof -iTCP:1883 -sTCP:LISTEN || true"], check=False)

    if system_name == "Windows":
        print("\n[INFO] Listening sockets on port 1883:")
        run_command([
            "powershell",
            "-NoProfile",
            "-Command",
            "netstat -ano | findstr :1883"
        ], check=False)


def remove():
    remove_container_if_exists()
    print("[OK] MQTT broker container removed if it existed.")


def test_hint():
    print("\nTest with MQTT clients:")
    print(f"  mosquitto_sub -h {BROKER_IP} -p {MQTT_PORT} -t \"#\"")
    print(f"  mosquitto_pub -h {BROKER_IP} -p {MQTT_PORT} -t \"test/topic\" -m \"hello\"")


def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python3 run_mqtt_broker.py start")
        print("  python3 run_mqtt_broker.py stop")
        print("  python3 run_mqtt_broker.py restart")
        print("  python3 run_mqtt_broker.py logs")
        print("  python3 run_mqtt_broker.py status")
        print("  python3 run_mqtt_broker.py remove")
        print("  python3 run_mqtt_broker.py test")
        sys.exit(1)

    command = sys.argv[1].lower()

    if command == "start":
        start_broker()
        test_hint()
    elif command == "stop":
        stop_broker()
    elif command == "restart":
        restart_broker()
        test_hint()
    elif command == "logs":
        logs()
    elif command == "status":
        status()
    elif command == "remove":
        remove()
    elif command == "test":
        test_hint()
    else:
        print(f"[ERROR] Unknown command: {command}")
        sys.exit(1)


if __name__ == "__main__":
    main()