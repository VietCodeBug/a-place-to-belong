#!/usr/bin/env bash
set -euo pipefail
# Install a user-writable pinned CLI without modifying the project or system.
cli_dir=/workspace/.tools/godot-4.6.3
mkdir -p "$cli_dir"
archive=Godot_v4.6.3-stable_linux.x86_64.zip
binary=Godot_v4.6.3-stable_linux.x86_64
if [[ ! -x "$cli_dir/$binary" ]]; then
  curl --fail --location --retry 3 "https://github.com/godotengine/godot/releases/download/4.6.3-stable/$archive" -o "$cli_dir/$archive"
  (cd "$cli_dir" && printf '%s  %s\n' 'a035258da32b77f966a5376f9fa29c30a6adde826a85ba918e1605bd1fc9823eba7d85f1dd5e748956bd2ba72827c0025ffa11bb82aec91128c407a2e723c99c' "$archive" | sha512sum --check -)
  unzip -o "$cli_dir/$archive" -d "$cli_dir"
  chmod +x "$cli_dir/$binary"
fi
"$cli_dir/$binary" --version
