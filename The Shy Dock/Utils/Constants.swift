//
//  Constants.swift
//  The Shy Dock
//
//  Created by Vova on 2024-09-07.
//

import Foundation
import AppKit

/// Global constants for The Shy Dock application
enum Constants {
    
    // MARK: - App Information
    enum App {
        static let name = "The Shy Dock"
        static let settingsTitle = "The Shy Dock Settings"
        static let subtitle = "Show dock when external displays connected"
        static let iconHidden = "🫣"
        static let iconVisible = "😎"
    }
    
    // MARK: - UserDefaults Keys
    enum UserDefaultsKeys {
        static let enabled = "TheShyDock_Enabled"
        static let minWidth = "TheShyDock_MinWidth"
        static let minHeight = "TheShyDock_MinHeight"
        static let launchAtLogin = "TheShyDock_LaunchAtLogin"
    }
    
    // MARK: - UI Dimensions
    enum UI {
        static let settingsWindowWidth: CGFloat = 420
        static let settingsWindowHeight: CGFloat = 300
        static let standardMargin: CGFloat = 24
        static let sectionSpacing: CGFloat = 32
        static let itemSpacing: CGFloat = 12
        static let indentSpacing: CGFloat = 18
        static let textFieldWidth: CGFloat = 70
        static let presetButtonSpacing: CGFloat = 8
    }
    
    // MARK: - Typography
    enum Typography {
        static let titleSize: CGFloat = 20
        static let titleWeight: NSFont.Weight = .semibold
        static let subtitleSize: CGFloat = 13
        static let bodySize: CGFloat = 13
        static let captionSize: CGFloat = 11
        static let labelSize: CGFloat = 12
    }
    
    // MARK: - Menu Items
    enum MenuItems {
        static let toggleDock = "Toggle Dock"
        static let enableAutoHide = "Enable Auto-Hide"
        static let disableAutoHide = "Disable Auto-Hide"
        static let settings = "Settings..."
        static let enableLaunchAtLogin = "Enable Launch at Login"
        static let disableLaunchAtLogin = "Disable Launch at Login"
        static let quit = "Quit The Shy Dock"
    }
    
    // MARK: - Status Messages
    enum StatusMessages {
        static let autoHideDisabled = "Auto-hide disabled"
        static let displayConnectedDockShowing = "Display connected • Dock showing"
        static let noDisplayDockHidden = "No display • Dock hidden"
        static let permissionRequired = "⚠️ Accessibility permission required"
        static let permissionGranted = "✅ Accessibility permission granted"
    }
    
    // MARK: - SF Symbols
    enum SFSymbols {
        static let dockRectangle = "dock.rectangle"
        static let dockRectangleSlash = "dock.rectangle.slash"
        static let exclamationmarkTriangle = "exclamationmark.triangle"
    }
    
    // MARK: - Keyboard Shortcuts
    enum KeyboardShortcuts {
        static let toggleDockKey = "d"
        static let settingsKey = ","
        static let quitKey = "q"
        static let toggleDockModifiers: NSEvent.ModifierFlags = [.command, .option]
    }
    
    // MARK: - Tooltips
    enum Tooltips {
        static let disabled = "The Shy Dock - Disabled"
        static let hidden = "The Shy Dock - Hidden (no external display)"
        static let visible = "The Shy Dock - Visible (external display connected)"
        static let permissionRequired = "The Shy Dock - Accessibility permission required"
    }
    
    // MARK: - Settings Labels
    enum SettingsLabels {
        static let autoHideDock = "Hide dock when no external display"
        static let launchAtLogin = "Launch at login"
        static let highResolutionOnly = "High-resolution displays only"
        static let helpText = "When disabled, any external display will trigger"
        static let minimumResolution = "Minimum resolution:"
        static let permissionStatus = "Accessibility Permission:"
        static let permissionRequired = "Required for dock control"
        static let grantPermission = "Grant Permission"
        static let openSystemPreferences = "Open System Preferences"
        
        // Preset buttons
        static let preset1080p = "1080p"
        static let preset1440p = "1440p"
        static let preset4K = "4K"
        
        // Placeholder text
        static let widthPlaceholder = "1920"
        static let heightPlaceholder = "1080"
    }
    
    // MARK: - Default Values
    enum Defaults {
        static let enabled = true
        static let minResolutionWidth: Double = 0  // 0 means no filtering
        static let minResolutionHeight: Double = 0
        static let launchAtLogin = false
        
        // Common resolution presets
        enum Resolutions {
            static let hd = (width: 1920.0, height: 1080.0)
            static let qhd = (width: 2560.0, height: 1440.0)
            static let uhd = (width: 3840.0, height: 2160.0)
        }
    }
    
    // MARK: - Error Messages
    enum ErrorMessages {
        static let accessibilityPermissionDenied = "Accessibility permission not granted"
        static let launchAtLoginFailed = "Failed to update launch at login"
        static let permissionPromptTitle = "Accessibility Permission Required"
        static let permissionPromptMessage = "The Shy Dock needs accessibility permission to control the dock. Please grant permission in System Preferences > Privacy & Security > Accessibility."
    }
} 