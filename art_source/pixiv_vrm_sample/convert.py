"""Convert the pinned Pixiv VRM 1.0 sample to native Godot glTF and a joint map."""
import argparse
import hashlib
import json
import struct
from pathlib import Path

SOURCE_SHA256 = "12c2b97e95e700783a6a550dc0eee2d7880aeedccef9ae67bc4c5a2f0f2631a2"
BODY = {"hips": "Hips", "spine": "Spine", "chest": "Spine1",
        "upperChest": "Spine2", "head": "Head", "neck": "Neck"}
SIDES = {"Shoulder": "Shoulder", "UpperArm": "Arm", "LowerArm": "ForeArm",
         "Hand": "Hand", "UpperLeg": "UpLeg", "LowerLeg": "Leg",
         "Foot": "Foot", "Toes": "ToeBase", "Eye": "Eye"}


def roles():
    names = dict(BODY)
    for side in ["Left", "Right"]:
        for vrm, rig in SIDES.items():
            names[side.lower() + vrm] = side + rig
        for digit in ["Thumb", "Index", "Middle", "Ring", "Little"]:
            joints = ["Metacarpal", "Proximal", "Distal"] if digit == "Thumb" else [
                "Proximal", "Intermediate", "Distal"]
            finger = "Pinky" if digit == "Little" else digit
            for number, joint in enumerate(joints, 1):
                names[side.lower() + digit + joint] = f"{side}Hand{finger}{number}"
    return names


def convert(source, output):
    data = source.read_bytes()
    if hashlib.sha256(data).hexdigest() != SOURCE_SHA256:
        raise ValueError("Unexpected version of the Pixiv sample")
    length = struct.unpack_from("<I", data, 12)[0]
    document = json.loads(data[20:20 + length])
    binary = data[20 + length:]
    avatar = document.pop("extensions")["VRMC_vrm"]
    names = roles()
    nodes = document["nodes"]
    for role, entry in avatar["humanoid"]["humanBones"].items():
        nodes[entry["node"]]["name"] = names[role]
    # Godot uses the same skinned mesh and textures. The native presentation
    # adapter evaluates the sample's arm and shoulder constraints.
    constraints = []
    for node in nodes:
        extension = node.pop("extensions", {}).get("VRMC_node_constraint")
        if extension:
            kind, rule = next(iter(extension["constraint"].items()))
            axis = rule.get("aimAxis", rule.get("rollAxis"))
            constraints.append([node["name"], nodes[rule["source"]]["name"], kind, axis, rule["weight"]])
    document.pop("extensionsUsed", None)
    document.pop("extensionsRequired", None)
    for material in document["materials"]:
        material.pop("extensions", None)
        pbr = material["pbrMetallicRoughness"]
        pbr["metallicFactor"] = 0
        pbr["roughnessFactor"] = .88
        if material["name"].endswith("_SKIN"):
            # Approximate the warmer MToon skin shading in the native PBR lighting.
            pbr["baseColorFactor"] = [.83, .67, .59, 1]
    output.mkdir(parents=True, exist_ok=True)
    manifest = {"source_sha256": SOURCE_SHA256,
                "source": "https://github.com/pixiv/three-vrm/blob/5a3242b66124386c32b085c6693d9059040e72e5/packages/three-vrm/examples/models/VRM1_Constraint_Twist_Sample.vrm",
                "license": avatar["meta"], "constraints": constraints}
    (output / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    payload = json.dumps(document, separators=(",", ":")).encode()
    payload += b" " * (-len(payload) % 4)
    header = struct.pack("<4sII", b"glTF", 2, 20 + len(payload) + len(binary))
    glb = header + struct.pack("<I4s", len(payload), b"JSON") + payload + binary
    (output / "pixiv_twist_sample.glb").write_bytes(glb)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    arguments = parser.parse_args()
    convert(arguments.source, arguments.output)
