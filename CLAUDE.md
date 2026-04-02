# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

```bash
# Build the library
xcodebuild -project JoyConSwift.xcodeproj -scheme JoyConSwift build

# Build the sample app
xcodebuild -project Sample/JoyConSwiftSample.xcodeproj -scheme JoyConSwiftSample build

# Open library in Xcode
open JoyConSwift.xcodeproj

# Open sample app in Xcode
open Sample/JoyConSwiftSample.xcodeproj
```

There are no automated tests in this project.

## Architecture

**JoyConSwift** is a macOS Swift library (IOKit wrapper) for Nintendo Joy-Con, Pro Controller, Famicom Controller, and SNES Controller. It uses `IOKit.hid` to communicate with controllers over Bluetooth HID.

### Core class hierarchy

- **`JoyConManager`** (`Source/JoyConManager.swift`) — entry point. Creates an `IOHIDManager`, filters for Nintendo vendor ID (`0x057E`) across known product IDs, and dispatches connect/disconnect events. On first connect it sends an SPI flash read to detect the controller type, then instantiates the appropriate subclass.

- **`Controller`** (`Source/Controller.swift`) — base class for all controllers. Handles:
  - Subcommand queue: commands are serialized via `subcommandQueue`/`processingSubcommand` with a 1-second timeout per command.
  - Three input report modes: simple (`0x3F`), standard+ACK (`0x21`), standard+sensor (`0x30`).
  - SPI flash reads (`readSPIFlash`) for fetching factory/user calibration data at well-known addresses.
  - Stick position calculation with dead zone and direction quantization.
  - IMU (accelerometer + gyro) data parsing with factory/user calibration fallback.
  - Public API: `sendRumbleData`, `setPlayerLights`, `setHomeLight`, `enableIMU`, `setInputMode`, `enableVibration`, `setHCIState`, `readControllerColor`.

- **Controller subclasses** (`Source/controllers/`):
  - `JoyConL` — left Joy-Con; handles left buttons and left stick.
  - `JoyConR` — right Joy-Con; handles right buttons/ABXY and right stick.
  - `ProController` — full controller with both sticks and all buttons.
  - `FamicomController1` / `FamicomController2` — Famicom controllers (simple button-only, no sticks/IMU).
  - `SNESController` — SNES controller (simple button-only).

- **`JoyCon`** (`Source/JoyCon.swift`) — namespace enum holding all public type definitions: `ControllerType`, `Button`, `StickDirection`, `BatteryStatus`, `InputMode`, `OutputType`, `HCIState`, `PlayerLightPattern`.

- **`Subcommand`** (`Source/Subcommand.swift`) — value type wrapping a queued HID subcommand with type, payload, response handler, and timeout timer.

- **`Rumble`** (`Source/Rumble.swift`) — enums for rumble frequency/amplitude encoding.

- **`HomeLEDPattern`** (`Source/HomeLEDPattern.swift`) — struct for Home button LED cycle data.

- **`Utils`** (`Source/Utils.swift`) — low-level helpers (`ReadInt16`, `ReadUInt16`, `ReadUInt32`) for reading little-endian values from raw byte pointers.

### Key design patterns

- Controller type is detected asynchronously: `JoyConManager.handleMatch` sends an SPI flash read for address `0x6012`; the response in `handleControllerType` instantiates the correct subclass.
- Subcommands are queued and processed one at a time. Each waits for an ACK/NACK before the next is sent. A 1-second `Timer` handles non-responding devices.
- Calibration data has two layers: factory (SPI addresses `0x60xx`) and user (SPI addresses `0x80xx`). User calibration takes precedence when present (magic bytes `0xB2A1`).
- `JoyConManager` must be used with a running `RunLoop`. Use `runAsync()` for background operation or `run()` to block the current thread.

### App Sandbox requirement

Any app using this library must enable **USB** capability under `Signing & Capabilities > App Sandbox > USB` in Xcode, or the `IOHIDManager` will fail to open.
