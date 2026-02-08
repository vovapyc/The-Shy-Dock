//
//  Dock.swift
//  The Shy Dock
//
//  Created by Vova on 2024-09-07.
//

import Foundation
import os

private let logger = Logger(subsystem: "com.vovawed.TheShyDock", category: "Dock")
private let maxRetries = 3
private let retryDelay: TimeInterval = 1.0

/// Runs an AppleScript with retries for when System Events isn't ready yet (error -600)
private func runAppleScript(_ source: String) -> NSAppleEventDescriptor? {
    for attempt in 1...maxRetries {
        let script = NSAppleScript(source: source)
        var error: NSDictionary?
        let result = script?.executeAndReturnError(&error)

        if let error = error {
            let errorCode = error[NSAppleScript.errorNumber] as? Int ?? 0
            // -600 = "Application isn't running" — System Events not ready yet
            if errorCode == -600 && attempt < maxRetries {
                logger.info("System Events not ready, retrying (\(attempt)/\(maxRetries))...")
                Thread.sleep(forTimeInterval: retryDelay)
                continue
            }
            logger.error("AppleScript failed: \(error)")
            return nil
        }

        return result
    }
    return nil
}

/// Returns the current Dock auto-hide state by querying System Events via AppleScript
/// - Returns: `true` if auto-hide is enabled, `false` otherwise
func isDockAutohideEnabled() -> Bool {
    let result = runAppleScript("tell application \"System Events\" to get autohide of dock preferences")
    return result?.booleanValue ?? false
}

/// Sets the Dock auto-hide preference via AppleScript and System Events
/// - Parameter hide: Whether to enable auto-hide
func setDockAutohide(_ hide: Bool) {
    _ = runAppleScript("tell application \"System Events\" to set autohide of dock preferences to \(hide)")
}

/// Hides the Dock by enabling auto-hide
func hideDock() {
    setDockAutohide(true)
}

/// Shows the Dock by disabling auto-hide
func showDock() {
    setDockAutohide(false)
}
