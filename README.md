# Vainquished realm

Vainquished realm is a virtual reality video game developped for a software engineering project at [ENSSAT](https://enssat.fr) by the Team Kiwi. This game is made with the [Godot engine](https://godotengine.org) ``v4.3`` and is configured to run on the Meta Quest VR headsets (tested with the Meta Quest 2 and 3). The game uses [Bastiaan Olij](https://github.com/BastiaanOlij)'s [OpenXR Vendors plugin](https://github.com/GodotVR/godot_openxr_vendors/releases) where every basic VR feature has been implemented in GDscript.  

**Next, you'll find an installation guide to try our game.**  
But if you're a programmer and want to dive deeper into the project, check out our wiki where we document every major feature to help you in your coding journey! 🚀  

[![Wiki](https://img.shields.io/badge/Wiki-Explore-blue?style=for-the-badge&logo=github)](https://github.com/dallatIkes/projetGL/wiki)  
  
Thank you for playing our game on behalf of the whole team, if you want to contact us, feel free to join our [official discord server](https://discord.gg/QdvcnQ6rES). Enjoy! 😉  

# 📥 Installation Guide

To install the project and build the game on your VR headset, you need the game's `.apk` file. You can either:

1. 🛠 **Build your own `.apk`** from the project using Godot.
2. 📦 **Use an existing `.apk`** and deploy it directly on your headset with the [Meta Quest Developer Hub](https://developers.meta.com/horizon/documentation/unity/ts-odh/).

---

## 📂 Contents

- [Build your own `.apk`](#-build-your-own-apk)
  - [Prerequisites](#-prerequisites)
  - [Set the SDK Paths](#-set-the-sdk-paths)
  - [Create the Export Preset](#-create-the-export-preset)
  - [Build on Your Headset](#-build-on-your-headset)
- [Use an existing `.apk`](#-use-an-already-existing-apk)

---

## 🛠 Build Your Own `.apk`

### 🔧 Prerequisites
Make sure you have the following installed:

- [Godot Engine `v4.3`](https://godotengine.org)
- [OpenJDK 17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html)
- [Android Studio](https://developer.android.com/studio?hl=fr)
  - 🪟/🍎 **Windows/macOS:** Launch Android Studio once after installation.
  - 🐧 **Linux:** Run the following in a terminal:
    ```bash
    cd {installation_home}/bin
    ./studio.sh
    ```

### 🔗 Set the SDK Paths
After installing the prerequisites, configure the SDK paths in Godot's Editor settings:

![SDK Paths](https://github.com/user-attachments/assets/54e1e9d0-0920-4cb0-bb3c-b4cce86f91ac)

Scroll down to the **Android settings** section:

![Android settings](https://github.com/user-attachments/assets/9abfb0f1-d480-47d2-9792-dc02d0b3b43c)

Use the following paths based on your OS:

- 🪟 **Windows:**
  - Java SDK: `C:/Program Files/Eclipse Adoptium/jdk-17.0.13.11-hotspot`
  - Android SDK: `C:/Users/{your_username}/AppData/Local/Android/Sdk`
- 🐧 **Linux:**
  - Java SDK: `/usr/lib/jvm/jdk-17.0.12-oracle-x64`
  - Android SDK: `~/Android/Sdk`
- 🍎 **macOS:**
  - Java SDK: `/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home`
  - Android SDK: `/Users/{your_username}/Library/Android/sdk`

---

### 🎛 Create the Export Preset
To build the project as an `.apk` file, create an **Android runnable export preset**:

![Export preset](https://github.com/user-attachments/assets/92f15a41-69d6-400f-8600-73f5c2050090)

Then, enable **Gradle build**:

![Gradle build](https://github.com/user-attachments/assets/0b4e0e4b-0151-4488-817d-dcc0046b9685)

Select **OpenXR** as the XR Mode in the XR Features menu:

![XR Features](https://github.com/user-attachments/assets/011b07ed-de38-482a-b0f3-b55595996e63)

Enable the **Meta Plugin**:

![Meta Plugin](https://github.com/user-attachments/assets/4cc974e6-05ce-4db7-b3fe-b879f29c578a)

---

### 🎮 Build on Your Headset
Once everything is set up, build the `.apk` and deploy it to your Meta Quest with remote debugging enabled:

![Build APK](https://github.com/user-attachments/assets/12b467f3-a9d7-434c-892f-30b1e9e8c54d)

#### 🛠 Troubleshooting
If you are on **Linux** and encounter an error with `adb`, remove the previous version with:

```bash
adb uninstall {your_project}
# Example: adb uninstall com.example.metrovr
```

---

## 📦 Use an Already Existing `.apk`

If you already have an `.apk` file, use the **Meta Quest Developer Hub** app to deploy it to your headset:

![Meta Quest Developer Hub](https://github.com/user-attachments/assets/a195d304-410e-4b30-b546-218da67ff1cf)

That’s it! 🚀 Enjoy your game on VR! 🎮

---

Enjoy our game - Team Kiwi

[![Discord](https://img.shields.io/discord/1291668818590044201?color=5865F2&logo=discord&logoColor=white)](https://discord.gg/QdvcnQ6rES)

## Repository view counter
<div align='center'><a href='https://www.websitecounterfree.com'><img src='https://www.websitecounterfree.com/c.php?d=9&id=65614&s=1' border='0' alt='Free Website Counter'></a><br / ><small><a href='https://www.websitecounterfree.com' title="Free Website Counter">Free Website Counter</a></small></div>
