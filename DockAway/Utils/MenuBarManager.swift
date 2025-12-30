//
//  MenuBarManager.swift
//  The Shy Dock
//
//  Created by Vova on 2024-09-07.
//

import SwiftUI
import AppKit
import ServiceManagement

/// Manages the menu bar interface and application state for The Shy Dock
final class MenuBarManager: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    private var statusItem: NSStatusItem?
    var settingsWindow: SettingsWindow?
    private var permissionCheckTimer: Timer?

    @Published var isExternalDisplayConnected = false
    @Published var isDockHidden = false
    @Published var minResolutionWidth = Constants.Defaults.minResolutionWidth
    @Published var minResolutionHeight = Constants.Defaults.minResolutionHeight
    @Published var launchAtLogin = Constants.Defaults.launchAtLogin
    @Published var hasAccessibilityPermission = false

    private let userDefaults = UserDefaults.standard
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        setupMenuBar()
        loadSettings()
        checkAccessibilityPermission()
        setupDisplayMonitoring()
        updateDisplayStatus()
        
        // Check permission status periodically
        permissionCheckTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.checkAccessibilityPermission()
        }
    }

    deinit {
        // Invalidate timer
        permissionCheckTimer?.invalidate()
        permissionCheckTimer = nil

        // Clean up display monitoring
        CGDisplayRemoveReconfigurationCallback(displayReconfigurationCallback, Unmanaged.passUnretained(self).toOpaque())
    }
    
    // MARK: - Setup Methods
    
    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        updateMenuBarIcon()
        createMenu()
    }
    
    private func updateMenuBarIcon() {
        guard let statusItem = statusItem else { return }

        statusItem.button?.title = ""

        let symbolName: String
        let isDisabled: Bool

        if !hasAccessibilityPermission {
            symbolName = Constants.SFSymbols.exclamationmarkTriangle
            isDisabled = true
        } else {
            symbolName = isDockHidden ? Constants.SFSymbols.dockRectangleSlash : Constants.SFSymbols.dockRectangle
            isDisabled = false
        }

        if let image = NSImage(systemSymbolName: symbolName, accessibilityDescription: Constants.App.name) {
            image.isTemplate = true
            statusItem.button?.image = image
            statusItem.button?.appearsDisabled = isDisabled
        }

        let tooltipText: String
        if !hasAccessibilityPermission {
            tooltipText = Constants.Tooltips.permissionRequired
        } else {
            tooltipText = isDockHidden ? Constants.Tooltips.hidden : Constants.Tooltips.visible
        }
        statusItem.button?.toolTip = tooltipText
    }
    
    private func createMenu() {
        let menu = NSMenu()
        
        // Status item
        let statusMenuItem = NSMenuItem()
        statusMenuItem.title = getStatusText()
        statusMenuItem.isEnabled = false
        menu.addItem(statusMenuItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Only show permission-related menu items if there's a problem
        if !hasAccessibilityPermission {
            // Grant permission option
            let grantPermissionMenuItem = NSMenuItem(
                title: Constants.SettingsLabels.grantPermission,
                action: #selector(requestPermission),
                keyEquivalent: ""
            )
            grantPermissionMenuItem.target = self
            menu.addItem(grantPermissionMenuItem)
            
            menu.addItem(NSMenuItem.separator())
        } else {
            // Manual toggle (only available with permission)
            let toggleMenuItem = NSMenuItem(
                title: Constants.MenuItems.toggleDock,
                action: #selector(toggleDockManually),
                keyEquivalent: Constants.KeyboardShortcuts.toggleDockKey
            )
            toggleMenuItem.keyEquivalentModifierMask = Constants.KeyboardShortcuts.toggleDockModifiers
            toggleMenuItem.target = self
            menu.addItem(toggleMenuItem)

            menu.addItem(NSMenuItem.separator())
        }
        
        // Settings (always available)
        let settingsMenuItem = NSMenuItem(
            title: Constants.MenuItems.settings,
            action: #selector(openSettings),
            keyEquivalent: Constants.KeyboardShortcuts.settingsKey
        )
        settingsMenuItem.target = self
        menu.addItem(settingsMenuItem)
        
        // Launch at login (always available)
        let launchMenuItemTitle = launchAtLogin ? Constants.MenuItems.disableLaunchAtLogin : Constants.MenuItems.enableLaunchAtLogin
        let launchMenuItem = NSMenuItem(title: launchMenuItemTitle, action: #selector(toggleLaunchAtLogin), keyEquivalent: "")
        launchMenuItem.target = self
        menu.addItem(launchMenuItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit
        let quitMenuItem = NSMenuItem(
            title: Constants.MenuItems.quit,
            action: #selector(quitApp),
            keyEquivalent: Constants.KeyboardShortcuts.quitKey
        )
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)
        
        statusItem?.menu = menu
    }
    
    private func getStatusText() -> String {
        if !hasAccessibilityPermission {
            return Constants.StatusMessages.permissionRequired
        } else if isExternalDisplayConnected {
            return isDockHidden ? Constants.StatusMessages.dockBeingShy : Constants.StatusMessages.dockVisible
        } else {
            return Constants.StatusMessages.externalDisplayNotConnected
        }
    }
    
    // MARK: - Action Methods
    
    @objc private func toggleDockManually() {
        let shouldHideDock = !isDockHidden
        
        if shouldHideDock {
            hideDock()
        } else {
            showDock()
        }
        
        // Update the state based on the action we just performed
        isDockHidden = shouldHideDock
        refreshMenu()
        
        // Verify the actual system state after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateDockStatus()
            self.refreshMenu()
        }
    }
    
    @objc private func toggleLaunchAtLogin() {
        launchAtLogin.toggle()
        saveSettings()
        
        updateLaunchAtLoginSetting()
        refreshMenu()
    }
    
    @objc private func openSettings() {
        // If window already exists, just bring it to front
        if let existingWindow = settingsWindow {
            // Activate the app and bring window to front
            NSApp.activate(ignoringOtherApps: true)
            existingWindow.showWindow(nil)
            existingWindow.window?.makeKeyAndOrderFront(nil)
            return
        }
        
        // Create new settings window
        settingsWindow = SettingsWindow(manager: self)
        
        // Activate the app and bring window to front
        NSApp.activate(ignoringOtherApps: true)
        settingsWindow?.showWindow(nil)
        settingsWindow?.window?.makeKeyAndOrderFront(nil)
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    @objc func requestPermission() {
        _ = requestAccessibilityPermission()
        
        // Show an alert explaining what to do
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showPermissionAlert()
        }
    }
    
    // MARK: - Permission Management
    
    private func checkAccessibilityPermission() {
        let newPermissionStatus = The_Shy_Dock.hasAccessibilityPermission()
        if newPermissionStatus != self.hasAccessibilityPermission {
            self.hasAccessibilityPermission = newPermissionStatus
            refreshMenu()
        }
    }
    
    private func showPermissionAlert() {
        let alert = NSAlert()
        alert.messageText = Constants.ErrorMessages.permissionPromptTitle
        alert.informativeText = Constants.ErrorMessages.permissionPromptMessage
        alert.alertStyle = .informational
        alert.addButton(withTitle: Constants.SettingsLabels.openSystemPreferences)
        alert.addButton(withTitle: "OK")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            openSystemPreferences()
        }
    }
    
    private func openSystemPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
    }
    
    // MARK: - Private Helper Methods
    
    private func refreshMenu() {
        createMenu()
        updateMenuBarIcon()
    }
    
    private func updateLaunchAtLoginSetting() {
        if #available(macOS 13.0, *) {
            do {
                if launchAtLogin {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                showAlert(title: "Error", message: "\(Constants.ErrorMessages.launchAtLoginFailed): \(error.localizedDescription)")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    // MARK: - Display Monitoring
    
    private func setupDisplayMonitoring() {
        // Register display reconfiguration callback with proper memory management
        CGDisplayRegisterReconfigurationCallback(displayReconfigurationCallback, Unmanaged.passUnretained(self).toOpaque())
    }
    
    func updateDisplayStatus() {
        let wasConnected = isExternalDisplayConnected
        isExternalDisplayConnected = checkExternalDisplayConnected()

        if wasConnected != isExternalDisplayConnected {
            updateDockBehavior()
        }

        updateDockStatus()
        refreshMenu()
    }
    
    private func checkExternalDisplayConnected() -> Bool {
        let screens = NSScreen.screens
        
        // Check each screen to see if any are external displays
        for screen in screens {
            if let displayID = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID {
                if CGDisplayIsBuiltin(displayID) == 0 {
                    // This is an external display
                    
                    // If resolution filtering is disabled (values are 0 or very small), accept any external display
                    if minResolutionWidth <= 1 || minResolutionHeight <= 1 {
                        return true
                    }
                    
                    // Otherwise, check if the display meets resolution requirements
                    let frame = screen.frame
                    if frame.width >= minResolutionWidth && frame.height >= minResolutionHeight {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    private func updateDockBehavior() {
        if isExternalDisplayConnected {
            showDock()
        } else {
            hideDock()
        }
    }
    
    private func updateDockStatus() {
        isDockHidden = isDockAutohideEnabled()
    }
    
    // MARK: - Settings Management
    
    private func loadSettings() {
        minResolutionWidth = userDefaults.object(forKey: Constants.UserDefaultsKeys.minWidth) as? Double ?? Constants.Defaults.minResolutionWidth
        minResolutionHeight = userDefaults.object(forKey: Constants.UserDefaultsKeys.minHeight) as? Double ?? Constants.Defaults.minResolutionHeight
        launchAtLogin = userDefaults.object(forKey: Constants.UserDefaultsKeys.launchAtLogin) as? Bool ?? Constants.Defaults.launchAtLogin
    }

    func saveSettings() {
        userDefaults.set(minResolutionWidth, forKey: Constants.UserDefaultsKeys.minWidth)
        userDefaults.set(minResolutionHeight, forKey: Constants.UserDefaultsKeys.minHeight)
        userDefaults.set(launchAtLogin, forKey: Constants.UserDefaultsKeys.launchAtLogin)
    }
    
    func updateResolutionSettings(width: Double, height: Double) {
        minResolutionWidth = width
        minResolutionHeight = height
        saveSettings()
        updateDisplayStatus()
    }
}

// MARK: - Display Reconfiguration Callback

/// C function callback for display reconfiguration events
private let displayReconfigurationCallback: CGDisplayReconfigurationCallBack = { (display, flags, userInfo) in
    // Safely cast userInfo back to MenuBarManager
    guard let userInfo = userInfo else { return }
    let manager = Unmanaged<MenuBarManager>.fromOpaque(userInfo).takeUnretainedValue()
    
    DispatchQueue.main.async {
        manager.updateDisplayStatus()
    }
}

// MARK: - NSWindowDelegate

extension MenuBarManager: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        if notification.object as? NSWindow === settingsWindow?.window {
            settingsWindow = nil
        }
    }
} 