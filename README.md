# 🔒 FlagSecure + Screenshot Observer Disabler

A `Magisk/KSU` module for advanced users and custom ROM developers.

---

## 🚨 **DISCLAIMER**

> - This module is intended for rooted users who have already voided their device's warranty by rooting.
> - By downloading, installing, or using this module, you acknowledge and agree that you assume full responsibility for any and all risks, including potential damage to your device, data loss, soft-bricks, hard-bricks, or any other issues that may arise from its use.
> - You assume responsibility for potentially violating legal agreements or terms of service with third-party apps you use. The developer does not promote or endorse the violation of any third-party app's terms of service; the user is solely responsible for accepting and adhering to those terms and for any modifications made to their device.

---

## 💻 **Compatibility**

* Any Android device with **Magisk**, **KSU**, or their derivatives.
* Added support to ``miui-services.jar`` (HyperOS)
* Tested on Android 10-15.

---

## ℹ️ **About**

* **FlagSecure Disabler**
  
  Gives you the freedom to take screenshots anywhere on your device, without restrictions
* **Screenshot Observer Disabler (Android 14+)**
  
  Allows you to prevent third-party apps from registering when you take screenshots.  
  
  **⚠️ Warning**: Disabling the Screenshot Observer may interfere with the functionality of specialized screenshot apps that rely on detecting screenshot events.
* **DRM (Digital Restrictions Management) Disabler**
  
  Provides a basic solution for multimedia content that won't load or displays an error message due to DRM verification failures.
  
  **⚠️ Warning**: This isn't a true fix for the DRM; rather, it's a force solution that disables it. While it may work in most cases, it can also cause limitations in some apps, such as preventing the use of high-quality options and more.
---

## 🚀 **Installation**

1. Get the latest `FlagSecure-Disabler.zip` from [Here](https://blassgo.blogspot.com/#id=android-projects-user&author=BlassGO&category=MAGISK&year=2025&title=FlagSecure%20Disabler).
2. Install via Magisk/KSU: Wait patiently, the process may take a while.
3. You will be prompted to disable the **Screenshot Observer**:
   - Press **Volume Up** to disable.
   - Press **Volume Down** to skip.
4. You will be prompted to disable the **DRM**:
   - Press **Volume Up** to disable.
   - Press **Volume Down** to skip.
5. **Reboot** your device once flashing is complete.
6. Now, try taking screenshots freely!

---

## 📝 **Integrating Changes**

Once you've confirmed the patch works properly on your device, apply it to your Custom ROM as follows:

1. **Copy or ask your tester for `/system/framework/services.jar`.**
   
   **HyperOS:** Also copy or ask your tester for `/system_ext/framework/miui-services.jar`.
2. Please include proper credits and acknowledge the original source of these modifications in your ROM's documentation.

---

## ☕ **Support the Developer**

If you find this module useful, consider buying me a coffee to support my work! If you're not able to, starring the repository helps a lot too!

<a href="https://www.buymeacoffee.com/BlassGO" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 50px !important;width: 170px !important;" ></a>

---

## ✨ **Credits**

* **[BlassGO](https://github.com/BlassGO)**: Developer of this module.
* **[DynamicInstaller](https://github.com/BlassGO/DynamicInstaller)**: Base framework used.