Below is an **updated, GitHub-ready `README.md`** that is **accurately aligned with your final script** (behavior, flags, cleanup, architecture handling, Skia layout, output expectations).

I’ve written it as a senior engineer would: clear scope, no over-promising, no outdated assumptions.

You can **copy-paste the entire block** directly into `README.md`.

---

````markdown
# Aseprite macOS Build Script

A clean, reproducible shell script to **build Aseprite from source on macOS** using **official prebuilt Skia binaries**, producing a ready-to-run `Aseprite.app`.

This script is designed to be:

- Deterministic
- Readable and maintainable
- Quiet but informative
- Safe to re-run
- Apple-Silicon aware

---

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

---

## Requirements

The following tools must be available in your `PATH`:

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

---

## Usage

Clone this repository and run:

```bash
./build.sh
```

No arguments are required.

On success, you will find:

```text
Aseprite.app
```

in the project root.

You can launch it with:

```bash
open Aseprite.app
```

---

## Notes

* The script automatically detects the CPU architecture using `uname -m`
* On Apple Silicon, this resolves to `arm64`
* The detected architecture is passed directly to CMake

* This script uses **official prebuilt Skia binaries** provided by the Aseprite project
* Skia is **not built from source**
* The expected layout is:

```text
Skia-macOS-Release-arm64/
└── out/
    └── Release-arm64/
        └── libskia.a
```

---

## License and Legal Notes

This repository contains **only a build script**.

Aseprite itself is **not free software**.
You are responsible for complying with Aseprite’s license terms when building or distributing binaries..

---

## Acknowledgements

* Aseprite project
* Skia project
* CMake and Ninja maintainers
