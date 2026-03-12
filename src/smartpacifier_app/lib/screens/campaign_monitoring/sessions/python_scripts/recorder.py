import os
import uuid
import time
import yaml
import h5py
import paho.mqtt.client as mqtt
from sensor_data_pb2 import IMUData, AIRFLOWData, PTData

BASE = os.path.dirname(os.path.abspath(__file__))
SESSIONS = os.path.abspath(os.path.join(BASE, ".."))

DATA_DIR = os.path.join(SESSIONS, "data")
META_DIR = os.path.join(SESSIONS, "metadata")

os.makedirs(DATA_DIR, exist_ok=True)
os.makedirs(META_DIR, exist_ok=True)

session_id = str(uuid.uuid4())

start_ts = time.strftime("%H:%M:%S")

timestamp = int(time.time()*1e9)

h5_name = f"session_{timestamp}.h5"
h5_path = os.path.join(DATA_DIR, h5_name)

print("Creating HDF5:", h5_path)

h5 = h5py.File(h5_path, "w")

# ---------- IMU GROUP ----------
imu_grp = h5.create_group("imu")
imu_grp.create_dataset("timestamp",(0,),maxshape=(None,))
imu_grp.create_dataset("temperature",(0,),maxshape=(None,))
imu_grp.create_dataset("acc_x",(0,),maxshape=(None,))
imu_grp.create_dataset("acc_y",(0,),maxshape=(None,))
imu_grp.create_dataset("acc_z",(0,),maxshape=(None,))
imu_grp.create_dataset("gyro_x",(0,),maxshape=(None,))
imu_grp.create_dataset("gyro_y",(0,),maxshape=(None,))
imu_grp.create_dataset("gyro_z",(0,),maxshape=(None,))

# ---------- AIRFLOW GROUP ----------
air_grp = h5.create_group("airflow")
air_grp.create_dataset("timestamp",(0,),maxshape=(None,))
air_grp.create_dataset("voltage_l",(0,),maxshape=(None,))
air_grp.create_dataset("voltage_r",(0,),maxshape=(None,))
air_grp.create_dataset("voltage_e",(0,),maxshape=(None,))
air_grp.create_dataset("temp_l",(0,),maxshape=(None,))
air_grp.create_dataset("temp_r",(0,),maxshape=(None,))
air_grp.create_dataset("temp_e",(0,),maxshape=(None,))

# ---------- PAT GROUP ----------
pat_grp = h5.create_group("pat")
pat_grp.create_dataset("timestamp",(0,),maxshape=(None,))
pat_grp.create_dataset("temperature",(0,),maxshape=(None,))
pat_grp.create_dataset("pressure",(0,),maxshape=(None,))


def append(ds, value):
    ds.resize((ds.shape[0] + 1,))
    ds[-1] = value


def on_message(client, userdata, msg):

    topic = msg.topic.split("/")

    if len(topic) < 3:
        return

    sensor = topic[2]

    t = time.time()

    try:

        if sensor == "imu":

            m = IMUData()
            m.ParseFromString(msg.payload)

            append(imu_grp["timestamp"], t)
            append(imu_grp["temperature"], m.temperature)

            append(imu_grp["acc_x"], m.acc.x)
            append(imu_grp["acc_y"], m.acc.y)
            append(imu_grp["acc_z"], m.acc.z)

            append(imu_grp["gyro_x"], m.gyro.x)
            append(imu_grp["gyro_y"], m.gyro.y)
            append(imu_grp["gyro_z"], m.gyro.z)


        elif sensor == "airflow":

            m = AIRFLOWData()
            m.ParseFromString(msg.payload)

            append(air_grp["timestamp"], t)

            append(air_grp["voltage_l"], m.voltage10kL)
            append(air_grp["voltage_r"], m.voltage10kR)
            append(air_grp["voltage_e"], m.voltage10kE)

            append(air_grp["temp_l"], m.tempL)
            append(air_grp["temp_r"], m.tempR)
            append(air_grp["temp_e"], m.tempE)


        elif sensor == "pat":

            m = PTData()
            m.ParseFromString(msg.payload)

            append(pat_grp["timestamp"], t)

            append(pat_grp["temperature"], m.temperature)
            append(pat_grp["pressure"], m.pressure)


    except Exception as e:
        print("Decode error:", e)


client = mqtt.Client()

client.connect("localhost",1883)

client.subscribe("Pacifier/#")

client.on_message = on_message


# --------- HDF5 METADATA ATTRIBUTES ---------

h5.attrs["session_id"] = session_id
h5.attrs["start_ts"] = start_ts
h5.attrs["patient_name"] = "David"


try:

    client.loop_forever()

finally:

    end_ts = time.strftime("%H:%M:%S")

    metadata = {
        "session_id": session_id,
        "start_ts": start_ts,
        "end_ts": end_ts,
        "patient":{
            "patient_id":"0001",
            "patient_name":"David",
            "age":21,
            "nationality":"DE"
        },
        "protobuf":{
            "name":"sensor_data.proto",
            "version":"1.0.0"
        },
        "hdf5_file": h5_name
    }

    yaml_path = os.path.join(META_DIR,"David.yaml")

    with open(yaml_path,"w") as f:
        yaml.dump(metadata,f)

    h5.close()