# JoyConSwift
IOKit wrapper for Nintendo Joy-Con and ProController (macOS, Swift)

[!NOTE]
To have the device seized by JoyConSwift, use the `seize-device` branch! This corresponds to the original behavior.

## Installation

### Using Swift Package Manager

Add the following to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/remokeitel/JoyConSwift.git", from: "1.1.0")
```

Or add via Xcode: **File > Add Package Dependencies…** and enter the repository URL.

## Set USB Capability

To use controllers, you need to check `Signing & Capabilities` > `App SandBox` > `USB` in your Xcode project.

<img width="367" alt="usb_capability" src="https://user-images.githubusercontent.com/1047810/82137704-5f7ea980-9855-11ea-8f21-0e6c2ad518e9.png">

## Usage

```swift
import JoyConSwift

// Initialize the manager
let manager = JoyConManager()

// Set connection event callbacks
manager.connectHandler = { controller in
    // Do something with the controller
    controller.setPlayerLights(l1: .on, l2: .off, l3: .off, l4: .off)
    controller.enableIMU(enable: true)
    controller.setInputMode(mode: .standardFull)
    controller.buttonPressHandler = { button in
        if button == .A {
            // Do something with the A button
        }
    }
}
manager.disconnectHandler = { controller in
    // Clean the controller data
}

// Start waiting for the connection events
manager.runAsync()
```

## Documentation

See [JoyConSwift Documentation](https://magicien.github.io/JoyConSwift/)

## Thanks to

[dekuNukem/Nintendo_Switch_Reverse_Engineering](https://github.com/dekuNukem/Nintendo_Switch_Reverse_Engineering) - A look at inner workings of Joycon and Nintendo Switch

## See also

[JoyKeyMapper](https://github.com/magicien/JoyKeyMapper) - Nintendo Joy-Con/ProController Key mapper for macOS
