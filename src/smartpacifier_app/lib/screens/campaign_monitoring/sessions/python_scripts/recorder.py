import os
import sys
import json
import time
import h5py

h5_path = sys.argv[1]

print("Recording to:", h5_path)

h5 = h5py.File(h5_path, "a")

def create_ds(group, name, units=None):

    if name in group:
        return group[name]

    ds = group.create_dataset(
        name,
        (0,),
        maxshape=(None,),
        chunks=True,
        dtype="f8"
    )

    if units:
        ds.attrs["units"] = units

    return ds


def append(ds, value):
    ds.resize((ds.shape[0] + 1,))
    ds[-1] = value


groups = {}

def get_group(name):

    if name not in groups:

        if name in h5:
            grp = h5[name]
        else:
            grp = h5.create_group(name)

        groups[name] = {
            "grp": grp,
            "timestamp": create_ds(grp, "timestamp", "seconds"),
            "datasets": {}
        }

    return groups[name]


print("Recorder ready")

for line in sys.stdin:

    try:

        pkt = json.loads(line)

        sensor = pkt["sensor"]
        t = float(pkt["timestamp"])
        values = pkt["values"]

        g = get_group(sensor)

        append(g["timestamp"], t)

        for key, value in values.items():

            if key not in g["datasets"]:
                g["datasets"][key] = create_ds(g["grp"], key)

            append(g["datasets"][key], value)

    except Exception as e:
        print("Recorder error:", e)

print("Closing file")
h5.close()