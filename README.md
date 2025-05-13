# iOS File Tweak Tool (PoC)

A simple iOS application that attempts to apply various UI and sound tweaks by zeroing out the first page of specific system files. This project is a Proof of Concept and demonstrates the use of a file-zeroing technique.

**⚠️ WARNING: EXPERIMENTAL SOFTWARE ⚠️**
This tool modifies system files. While the targeted files are generally for UI or sound resources, any modification to system files carries risk.
- **Use exclusively on a test device.**
- **Incorrect use or targeting the wrong files could lead to system instability, visual glitches, or in worst-case scenarios, require a device restore.**
- Most tweaks require a **manual respring or reboot** for changes to take effect.
- The effectiveness of these tweaks is highly dependent on the iOS version and device. They may not work as expected or at all on patched/newer iOS versions.
- Files on the Sealed System Volume (SSV) may be restored by the OS upon reboot.

**📸 IMPORTANT NOTE ON CAMERA SHUTTER SOUNDS 📸**
- **In some regions, such as South Korea and Japan, mobile phones are commonly manufactured or configured to always produce a camera shutter sound. This is typically due to industry standards, carrier requirements, or strong societal expectations aimed at preventing unauthorized photography.**
- While this tool provides the technical means to *attempt* to silence these sounds by modifying system files, users should be aware of the following:
    - The effectiveness of this tweak may be limited in regions where OS-level or hardware-level enforcements for shutter sounds exist.
    - Modifying your device to bypass these culturally or industry-expected norms may be viewed negatively or have social implications depending on your location and context.
- **Users are solely responsible for understanding the conventions and expectations regarding camera usage in their region.**
- This feature is provided for experimental purposes on test devices.
- 
## Features

-   Apply various UI tweaks (e.g., hide dock, transparent UI elements).
-   Apply sound tweaks (e.g., silence camera shutter, lock sound, keyboard clicks).
-   Grouped list of tweaks by category.
-   "Apply All" option for file-zeroing tweaks.
-   Activity log to see the status of operations.

## How It Works

The application uses a C-based exploit (based on the `VM_BEHAVIOR_ZERO_WIRED_PAGES` technique) to zero out the first page (typically 16KB) of targeted system files.
- It maps a read-only file into memory.
- Marks the memory entry with `VM_BEHAVIOR_ZERO_WIRED_PAGES`.
- Locks the page using `mlock()`.
- Deallocates the memory mapping, causing the kernel to zero out the underlying physical page backing that part of the file.
*(The effectiveness and precise low-level mechanics can vary by OS version and kernel mitigations.)*

## Requirements

-   An iOS device.
-   An iOS version where the underlying file-zeroing technique is effective (e.g., tested below iOS 18.4, but specific exploit viability can vary).
-   Xcode to build the project.

## Building and Installation

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/speedyfriend433/mdcX.git
    cd mdcX
    ```
2.  **Open in Xcode:**
    Open the `.xcodeproj` or `.xcworkspace` file.
3.  **Bridging Header:**
    Ensure the Objective-C Bridging Header is correctly set up in Build Settings and includes `exploit_poc.h`.
4.  **C Code:**
    The C files (`exploit_poc.c` and `exploit_poc.h`) containing the exploit logic must be part of the target's "Compile Sources" build phase.
5.  **Sign and Build:**
    Configure your bundle identifier and signing credentials in Xcode.
6.  **Create IPA:**
    Build the project and export the IPA.
7.  **Install:**
    Transfer the IPA to your device and install it using a sideloading utility like Sideloadly, AltStore, or if compatible, TrollStore.

## Usage

1.  Launch the app.
2.  Browse the list of available tweaks, grouped by category.
3.  Tap on a tweak's hammer icon (🔨) to apply it.
4.  Alternatively, use the "Apply All" button in the toolbar to attempt all listed file-zeroing tweaks.
5.  Observe the status messages and the activity log for results.
6.  **Manually respring or reboot your device** to see if the tweaks have taken effect.

## Disclaimer

This software is provided "as-is" without warranty of any kind. The authors or contributors are not responsible for any damage, data loss, or legal repercussions that may occur from its use. **Use at your own risk.** This tool is intended for educational and experimental purposes on test devices, in compliance with local laws.

## Credits

- @Google Project Zero - Thanks for the insane discovery!
  
- @34306 : Thanks for the basic knowledge explanations!

- @Mattycbtw : Thanks for the additional util paths!
 
- @sH1222J : Thanks for the readme.md correction report!

- @AppinstalleriOS & @GeoSn0w : Thanks for the Swift version of PoC Code!

## License

This project is licensed under the [MIT License](https://github.com/speedyfriend433/mdcX/blob/main/LICENSE). See the `LICENSE` file for details.
