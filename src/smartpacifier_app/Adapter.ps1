# setup-broker-ip.ps1
# Run as Administrator, once per machine. No firmware flashing, no router login.

# Auto-detect the ASIX USB ethernet adapter by its description
$adapter = Get-NetAdapter | Where-Object {
    $_.InterfaceDescription -like "*ASIX*" -or $_.InterfaceDescription -like "*USB*Ethernet*"
} | Select-Object -First 1

if (-not $adapter) {
    Write-Host "ERROR: USB ethernet adapter not found. Plug it in and re-run." -ForegroundColor Red
    exit 1
}

$alias = $adapter.Name
Write-Host "Found adapter: $alias ($($adapter.InterfaceDescription))"

# Pin the static IP
Set-NetIPInterface -InterfaceAlias $alias -Dhcp Disabled
Remove-NetIPAddress -InterfaceAlias $alias -AddressFamily IPv4 -Confirm:$false -ErrorAction SilentlyContinue
New-NetIPAddress -InterfaceAlias $alias -IPAddress 192.168.0.100 -PrefixLength 24

# Allow the ESP32 to reach the broker
New-NetFirewallRule -DisplayName "MQTT 1883" -Direction Inbound -Protocol TCP -LocalPort 1883 -Action Allow -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Done. This PC is now fixed at 192.168.0.100 and MQTT port 1883 is open." -ForegroundColor Green
Write-Host "You can close this window."