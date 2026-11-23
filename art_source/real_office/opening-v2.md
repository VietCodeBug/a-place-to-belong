# ENV-REAL-01 office opening

Enter from **Begin your day** or run `scenes/story/real_office.tscn`. The opening
and active play use the same first-person camera. Esc or Enter skips the opening.
Mouse looks around, WASD walks, Shift jogs, F switches posture at the chair, Q
checks the phone, and E reads the email or confirms leaving at the exit.

## Character A

The user-supplied source is `base_basic_pbr-801bec57.fbx` (SHA-256
`fe68cd00e6170694c29ad7d67b7bbb63e44608662b08c0c4c9f19a38c0faeacc`).
`convert_character_a.py` exports `assets/story/office_models/character_a.glb`
without editing the FBX. It retains 71 weighted bones and the original palette,
with 2K embedded base color, normals and packed metallic/roughness. The FBX
contains no animation actions. The office controller poses the skeleton, arms
and fingers at runtime. The head is a separate skinned mesh that casts shadows
in the eye view. The facial joints are preserved for future animation work.

Replace the Model slot in `scenes/story/opening_actor.tscn` with a +Z-facing
metre-scale model. The controller accepts the existing role names, standard
Mixamo bone names and the `mixamorig_` variants. For the eye view, the head
surface needs its own mesh named `OfficeHead`. A model swap may need new eye,
seat, keyboard and wrist positions.

Run `godot --headless --path . --script tests/office_first_person_test.gd`
to check the import, camera and office interactions.
