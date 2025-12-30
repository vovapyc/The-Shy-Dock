//
//  Dock.swift
//  The Shy Dock
//
//  Created by Vova on 2024-09-07.
//

import Foundation
import ApplicationServices

/// Checks if accessibility permissions are granted without prompting the user
/// - Returns: `true` if permissions are granted, `false` otherwise
func hasAccessibilityPermission() -> Bool {
    return AXIsProcessTrusted()
}

/// Prompts the user to grant accessibility permissions
/// - Returns: `true` if permissions are already granted, `false` if prompt was shown
func requestAccessibilityPermission() -> Bool {
    let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true] as CFDictionary
    return AXIsProcessTrustedWithOptions(options)
}

/// Returns the current Dock auto-hide state by reading system preferences
/// - Returns: `true` if auto-hide is enabled, `false` otherwise
func isDockAutohideEnabled() -> Bool {
    let key = "autohide" as CFString
    let domain = "com.apple.dock" as CFString
    var keyExists: DarwinBoolean = false
    let enabled = CFPreferencesGetAppBooleanValue(key, domain, &keyExists)
    return enabled
}

/// Sets the Dock auto-hide preference
/// - Parameter hide: Whether to enable auto-hide
func setDockAutohide(_ hide: Bool) {
    guard hasAccessibilityPermission() else {
        print("Accessibility permission not granted")
        return
    }

    let defaultsTask = Process()
    defaultsTask.executableURL = URL(fileURLWithPath: "/usr/bin/defaults")
    defaultsTask.arguments = ["write", "com.apple.dock", "autohide", "-bool", hide ? "true" : "false"]

    do {
        try defaultsTask.run()
        defaultsTask.waitUntilExit()

        let killTask = Process()
        killTask.executableURL = URL(fileURLWithPath: "/usr/bin/killall")
        killTask.arguments = ["Dock"]
        try killTask.run()
        killTask.waitUntilExit()
    } catch {
        print("Failed to set dock autohide: \(error)")
    }
}

/// Hides the Dock by enabling auto-hide
func hideDock() {
    setDockAutohide(true)
}

/// Shows the Dock by disabling auto-hide
func showDock() {
    setDockAutohide(false)
}


