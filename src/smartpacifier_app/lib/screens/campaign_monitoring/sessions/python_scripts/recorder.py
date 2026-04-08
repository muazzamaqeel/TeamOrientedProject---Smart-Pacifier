import sys
import json
import h5py
import math

h5_path = sys.argv[1]

print("Recording to:", h5_path)
h5 = h5py.File(h5_path, "a")

def create_ds(group, name, units=None):
    if name in group:
        ds = group[name]
    else:
        ds = group.create_dataset(
            name,
            shape=(0,),
            maxshape=(None,),
            chunks=True,
            dtype="f8"
        )
        if units:
            ds.attrs["units"] = units
    return ds

def append_value(ds, value):
    ds.resize((ds.shape[0] + 1,))
    ds[-1] = value

def append_nan(ds):
    ds.resize((ds.shape[0] + 1,))
    ds[-1] = float("nan")

groups = {}

def get_group(sensor_name):
    if sensor_name not in groups:
        if sensor_name in h5:
            grp = h5[sensor_name]
        else:
            grp = h5.create_group(sensor_name)

        timestamp_ds = create_ds(grp, "timestamp", "seconds")

        existing = {}
        for name, obj in grp.items():
            if name != "timestamp" and isinstance(obj, h5py.Dataset):
                existing[name] = obj

        groups[sensor_name] = {
            "grp": grp,
            "timestamp": timestamp_ds,
            "datasets": existing,
        }

    return groups[sensor_name]

print("Recorder ready")

for line in sys.stdin:
    try:
        pkt = json.loads(line)

        sensor = str(pkt["sensor"])
        t = float(pkt["timestamp"])
        values = pkt["values"]

        g = get_group(sensor)

        # 1. append timestamp
        append_value(g["timestamp"], t)

        # 2. append NaN to ALL existing datasets for this new time step
        for ds in g["datasets"].values():
            append_nan(ds)

        # 3. overwrite the last value for datasets present in this packet
        for key, value in values.items():
            key = str(key)

            if key not in g["datasets"]:
                ds = create_ds(g["grp"], key)
                # backfill old rows with NaN so length matches timestamp
                current_len = g["timestamp"].shape[0]
                ds.resize((current_len,))
                ds[:] = float("nan")
                g["datasets"][key] = ds

            g["datasets"][key][-1] = float(value)

        h5.flush()

    except Exception as e:
        print("Recorder error:", e)

print("Closing file")
h5.close()