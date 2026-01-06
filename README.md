# Aseprite macOS Build Script

Shell script to **build Aseprite from source on macOS** using **official prebuilt Skia binaries**, producing a ready-to-run `Aseprite.app`.

## What This Script Does

When run, the script will:

1. Verify required build tools are available
2. Clone the Aseprite repository (including submodules)
3. Download the official prebuilt Skia binaries for macOS
4. Configure Aseprite with CMake
5. Build Aseprite using Ninja
6. Produce a macOS `.app` bundle
7. Copy `Aseprite.app` to the project root
8. Remove all intermediate build artifacts

At the end, **only `Aseprite.app` remains**.

## Requirements

Before runnging the script, make sure you have the following tools in your `PATH`:

- `git`
- `curl`
- `unzip`
- `cmake`
- `ninja`

On macOS, you can install them with Homebrew:

```bash
brew update
brew install git curl unzip cmake ninja
````

You will also need **Xcode** or at least the **Xcode Command Line Tools**.

```bash
xcode-select --install
```

## Usage

Clone this repository and run:

```bash
./build_aseprite.sh
```

No arguments are required.

On success, you will find:

```text
Aseprite.app
```

in the project root.

## License and Legal Notes

This repository contains **only a build script**.

Aseprite itself is **not free software**.
You are responsible for complying with Aseprite’s license terms when building or distributing binaries..
