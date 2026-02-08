//
//  Dock.swift
//  The Shy Dock
//
//  Created by Vova on 2024-09-07.
//

import Foundation
import os

private let logger = Logger(subsystem: "com.vovawed.TheShyDock", category: "Dock")
private let dockQueue = DispatchQueue(label: "com.vovawed.TheShyDock.dock", qos: .userInitiated)
private let maxRetries = 3
private let retryDelay: TimeInterval = 1.0

/// Runs an AppleScript on a background queue with retries for error -600
private func runAppleScript(_ source: String, completion: @escaping (NSAppleEventDescriptor?) -> Void) {
    dockQueue.async {
        for attempt in 1...maxRetries {
            let script = NSAppleScript(source: source)
            var error: NSDictionary?
            let result = script?.executeAndReturnError(&error)

            if let error = error {
                let errorCode = error[NSAppleScript.errorNumber] as? Int ?? 0
                if errorCode == -600 && attempt < maxRetries {
                    logger.info("System Events not ready, retrying (\(attempt)/\(maxRetries))...")
                    Thread.sleep(forTimeInterval: retryDelay)
                    continue
                }
                logger.error("AppleScript failed: \(error)")
                DispatchQueue.main.async { completion(nil) }
                return
            }

            DispatchQueue.main.async { completion(result) }
            return
        }
        DispatchQueue.main.async { completion(nil) }
    }
}

/// Returns the current Dock auto-hide state by querying System Events via AppleScript
func isDockAutohideEnabled(completion: @escaping (Bool) -> Void) {
    runAppleScript("tell application \"System Events\" to get autohide of dock preferences") { result in
        completion(result?.booleanValue ?? false)
    }
}

/// Sets the Dock auto-hide preference via AppleScript and System Events
func setDockAutohide(_ hide: Bool) {
    runAppleScript("tell application \"System Events\" to set autohide of dock preferences to \(hide)") { _ in }
}

/// Hides the Dock by enabling auto-hide
func hideDock() {
    setDockAutohide(true)
}

/// Shows the Dock by disabling auto-hide
func showDock() {
    setDockAutohide(false)
}
