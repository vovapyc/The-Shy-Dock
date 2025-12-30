# The Shy Dock v1.0 🚀

A beautiful, dead-simple macOS menu bar utility that intelligently manages your Dock based on external monitor connections.

## ✨ Features

### Core Functionality
- **Smart Dock Management**: Automatically hides the Dock when external monitors are connected
- **Resolution Threshold**: Set minimum screen resolution requirements (1080p, 1440p, 4K presets)
- **Menu Bar Integration**: Clean, native menu bar presence with real-time status
- **Manual Toggle**: Quick Cmd+Opt+D shortcut for manual dock control
- **Smart Permission Handling**: Automatically detects and guides you through accessibility permission setup

### Menu Bar Controls
- 🖥️ **Real-time Status**: Shows current dock state and display connection status
- ⚡ **Quick Toggle**: Manual dock show/hide control (when permissions are granted)
- ⚙️ **Settings Window**: Beautiful, simple configuration interface
- 🚀 **Launch at Login**: One-click startup automation
- 🔧 **Permission Assistant**: One-click access to grant required permissions when needed
- ❌ **Quit Option**: Clean exit from menu bar

### Settings Interface
- Enable/disable automatic dock hiding
- Configure minimum resolution thresholds (width × height)
- Quick presets for common resolutions (1080p, 1440p, 4K)
- Launch at login toggle
- Real-time external display detection status
- **Integrated Permission Status**: Shows permission requirements in the status area when needed

## 🔐 Permissions
The Shy Dock requires **Accessibility permissions** to control the dock. The app automatically:
- Detects when permissions are missing
- Shows clear indicators in the menu bar and settings
- Provides one-click access to System Preferences
- Guides you through the permission grant process
- Updates the interface immediately when permissions are granted

**Permission indicators only appear when there's an issue - keeping the interface clean when everything is working.**

## 🎯 Target Audience
- Young professionals who care about clean workspaces and UX
- MacBook users with external monitors
- Anyone who dislikes unnecessary distractions and toolbars

## 🛠 Technical Details
- **Built with**: SwiftUI + AppKit
- **Architecture**: Menu bar only app (LSUIElement = true)
- **Permissions**: Requires Accessibility permissions for dock control
- **Compatibility**: macOS 14.5+
- **Resolution Detection**: Real-time display monitoring with configurable thresholds

## 🚀 Quick Start
1. Build and run the app in Xcode
2. Grant Accessibility permissions when prompted (the app will guide you)
3. Look for the dock icon in your menu bar
4. Click to access settings and controls

## ⌨️ Keyboard Shortcuts
- **Cmd+Opt+D**: Toggle dock visibility
- **Cmd+,**: Open settings (from menu)

## 🔧 Configuration
The app automatically saves your preferences:
- Auto-hide enabled/disabled state
- Resolution thresholds (default: 1920×1080)
- Launch at login preference

---

*Created with ❤️ for macOS power users who value clean, efficient workflows.* 