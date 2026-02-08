//
//  Dock.swift
//  The Shy Dock
//
//  Created by Vova on 2024-09-07.
//

import Foundation
import os

private let logger = Logger(subsystem: "com.vovawed.TheShyDock", category: "Dock")

/// Returns the current Dock auto-hide state by querying System Events via AppleScript
/// - Returns: `true` if auto-hide is enabled, `false` otherwise
func isDockAutohideEnabled() -> Bool {
    let script = NSAppleScript(source: "tell application \"System Events\" to get autohide of dock preferences")
    var error: NSDictionary?
    let result = script?.executeAndReturnError(&error)
    if let error = error {
        logger.error("Failed to read dock autohide state: \(error)")
        return false
    }
    return result?.booleanValue ?? false
}

/// Sets the Dock auto-hide preference via AppleScript and System Events
/// - Parameter hide: Whether to enable auto-hide
func setDockAutohide(_ hide: Bool) {
    let script = NSAppleScript(source: "tell application \"System Events\" to set autohide of dock preferences to \(hide)")
    var error: NSDictionary?
    script?.executeAndReturnError(&error)
    if let error = error {
        logger.error("Failed to set dock autohide: \(error)")
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
