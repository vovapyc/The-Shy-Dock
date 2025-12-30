//
//  SettingsWindow.swift
//  The Shy Dock
//
//  Created by Vova on 2024-09-07.
//

import AppKit
import Combine

/// Settings window for The Shy Dock application
final class SettingsWindow: NSWindowController {
    
    // MARK: - Properties
    
    private weak var manager: MenuBarManager?
    private var cancellables = Set<AnyCancellable>()
    
    // UI Controls
    private var launchAtLoginCheckbox: NSButton!
    private var useResolutionFilterCheckbox: NSButton!
    private var widthTextField: NSTextField!
    private var heightTextField: NSTextField!
    private var statusLabel: NSTextField!
    private var resolutionContainer: NSView!
    
    // MARK: - Initialization
    
    init(manager: MenuBarManager) {
        self.manager = manager
        
        let window = NSWindow(
            contentRect: NSRect(
                x: 0,
                y: 0,
                width: Constants.UI.settingsWindowWidth,
                height: Constants.UI.settingsWindowHeight
            ),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        super.init(window: window)
        
        window.title = Constants.App.settingsTitle
        window.center()
        window.delegate = self
        window.backgroundColor = NSColor.controlBackgroundColor
        
        setupUI()
        updateUI()
        setupObservations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Observation Setup
    
    private func setupObservations() {
        guard let manager = manager else { return }
        
        // Observe display-related changes
        manager.$isExternalDisplayConnected
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            }
            .store(in: &cancellables)
        
        manager.$isDockHidden
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            }
            .store(in: &cancellables)
        
        // Observe settings changes
        manager.$minResolutionWidth
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            }
            .store(in: &cancellables)
        
        manager.$minResolutionHeight
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            }
            .store(in: &cancellables)
        
        manager.$launchAtLogin
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            }
            .store(in: &cancellables)
        
        manager.$hasAccessibilityPermission
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        guard let contentView = window?.contentView else { return }
        
        // Main container view
        let mainView = NSView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainView)
        
        // Create sections
        let headerView = createHeaderSection()
        let settingsSection = createSettingsSection()
        let statusSection = createStatusSection()
        
        mainView.addSubview(headerView)
        mainView.addSubview(settingsSection)
        mainView.addSubview(statusSection)
        
        // Layout with proper constraints
        setupConstraints(
            mainView: mainView,
            contentView: contentView,
            headerView: headerView,
            settingsSection: settingsSection,
            statusSection: statusSection
        )
    }
    
    private func setupConstraints(
        mainView: NSView,
        contentView: NSView,
        headerView: NSView,
        settingsSection: NSView,
        statusSection: NSView
    ) {
        NSLayoutConstraint.activate([
            // Main view fills window
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Header section
            headerView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: Constants.UI.standardMargin),
            headerView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: Constants.UI.standardMargin),
            headerView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -Constants.UI.standardMargin),
            
            // Settings section
            settingsSection.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constants.UI.sectionSpacing),
            settingsSection.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: Constants.UI.standardMargin),
            settingsSection.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -Constants.UI.standardMargin),
            
            // Status section
            statusSection.topAnchor.constraint(equalTo: settingsSection.bottomAnchor, constant: Constants.UI.standardMargin),
            statusSection.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: Constants.UI.standardMargin),
            statusSection.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -Constants.UI.standardMargin),
            statusSection.bottomAnchor.constraint(lessThanOrEqualTo: mainView.bottomAnchor, constant: -Constants.UI.standardMargin),
        ])
    }
    
    private func createHeaderSection() -> NSView {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // App title with emoji
        let titleLabel = NSTextField(labelWithString: "\(Constants.App.iconHidden) \(Constants.App.name)")
        titleLabel.font = NSFont.systemFont(ofSize: Constants.Typography.titleSize, weight: Constants.Typography.titleWeight)
        titleLabel.textColor = .labelColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Subtitle
        let subtitleLabel = NSTextField(labelWithString: Constants.App.subtitle)
        subtitleLabel.font = NSFont.systemFont(ofSize: Constants.Typography.subtitleSize)
        subtitleLabel.textColor = .secondaryLabelColor
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        return view
    }
    
    private func createSettingsSection() -> NSView {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Create all checkboxes
        launchAtLoginCheckbox = createCheckbox(
            title: Constants.SettingsLabels.launchAtLogin,
            action: #selector(launchAtLoginChanged)
        )
        
        useResolutionFilterCheckbox = createCheckbox(
            title: Constants.SettingsLabels.highResolutionOnly,
            action: #selector(useResolutionFilterChanged)
        )
        
        // Help text
        let helpLabel = createLabel(
            text: Constants.SettingsLabels.helpText,
            fontSize: Constants.Typography.captionSize,
            color: .tertiaryLabelColor
        )
        
        // Resolution controls container
        resolutionContainer = NSView()
        resolutionContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let resolutionControls = createResolutionControls()
        resolutionContainer.addSubview(resolutionControls)
        
        // Add all views
        [launchAtLoginCheckbox, useResolutionFilterCheckbox, helpLabel, resolutionContainer].forEach {
            view.addSubview($0)
        }

        // Setup constraints
        setupSettingsSectionConstraints(
            view: view,
            helpLabel: helpLabel,
            resolutionControls: resolutionControls
        )
        
        return view
    }
    
    private func setupSettingsSectionConstraints(
        view: NSView,
        helpLabel: NSTextField,
        resolutionControls: NSView
    ) {
        NSLayoutConstraint.activate([
            launchAtLoginCheckbox.topAnchor.constraint(equalTo: view.topAnchor),
            launchAtLoginCheckbox.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            launchAtLoginCheckbox.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            useResolutionFilterCheckbox.topAnchor.constraint(equalTo: launchAtLoginCheckbox.bottomAnchor, constant: Constants.UI.itemSpacing),
            useResolutionFilterCheckbox.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            useResolutionFilterCheckbox.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            helpLabel.topAnchor.constraint(equalTo: useResolutionFilterCheckbox.bottomAnchor, constant: 4),
            helpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.UI.indentSpacing),
            helpLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            resolutionContainer.topAnchor.constraint(equalTo: helpLabel.bottomAnchor, constant: Constants.UI.itemSpacing),
            resolutionContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.UI.indentSpacing),
            resolutionContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resolutionContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            resolutionControls.topAnchor.constraint(equalTo: resolutionContainer.topAnchor),
            resolutionControls.leadingAnchor.constraint(equalTo: resolutionContainer.leadingAnchor),
            resolutionControls.trailingAnchor.constraint(equalTo: resolutionContainer.trailingAnchor),
            resolutionControls.bottomAnchor.constraint(equalTo: resolutionContainer.bottomAnchor),
        ])
    }
    
    private func createResolutionControls() -> NSView {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Resolution input label
        let resolutionLabel = createLabel(
            text: Constants.SettingsLabels.minimumResolution,
            fontSize: Constants.Typography.labelSize,
            color: .secondaryLabelColor
        )
        
        // Input fields container
        let inputContainer = createInputContainer()
        let presetContainer = createPresetButtonsContainer()
        
        view.addSubview(resolutionLabel)
        view.addSubview(inputContainer)
        view.addSubview(presetContainer)
        
        NSLayoutConstraint.activate([
            resolutionLabel.topAnchor.constraint(equalTo: view.topAnchor),
            resolutionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resolutionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            inputContainer.topAnchor.constraint(equalTo: resolutionLabel.bottomAnchor, constant: Constants.UI.itemSpacing),
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            presetContainer.topAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: Constants.UI.itemSpacing),
            presetContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            presetContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            presetContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        return view
    }
    
    private func createInputContainer() -> NSView {
        let container = NSView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        widthTextField = createTextField(placeholder: Constants.SettingsLabels.widthPlaceholder)
        heightTextField = createTextField(placeholder: Constants.SettingsLabels.heightPlaceholder)
        
        let multiplyLabel = createLabel(text: "×", fontSize: Constants.Typography.bodySize, color: .secondaryLabelColor)
        
        container.addSubview(widthTextField)
        container.addSubview(multiplyLabel)
        container.addSubview(heightTextField)
        
        NSLayoutConstraint.activate([
            widthTextField.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            widthTextField.topAnchor.constraint(equalTo: container.topAnchor),
            widthTextField.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            widthTextField.widthAnchor.constraint(equalToConstant: Constants.UI.textFieldWidth),
            
            multiplyLabel.leadingAnchor.constraint(equalTo: widthTextField.trailingAnchor, constant: Constants.UI.presetButtonSpacing),
            multiplyLabel.centerYAnchor.constraint(equalTo: widthTextField.centerYAnchor),
            
            heightTextField.leadingAnchor.constraint(equalTo: multiplyLabel.trailingAnchor, constant: Constants.UI.presetButtonSpacing),
            heightTextField.topAnchor.constraint(equalTo: container.topAnchor),
            heightTextField.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            heightTextField.widthAnchor.constraint(equalToConstant: Constants.UI.textFieldWidth),
            heightTextField.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor),
        ])
        
        return container
    }
    
    private func createPresetButtonsContainer() -> NSView {
        let container = NSView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let button1080p = createPresetButton(
            title: Constants.SettingsLabels.preset1080p,
            resolution: Constants.Defaults.Resolutions.hd,
            action: #selector(preset1080pClicked)
        )
        
        let button1440p = createPresetButton(
            title: Constants.SettingsLabels.preset1440p,
            resolution: Constants.Defaults.Resolutions.qhd,
            action: #selector(preset1440pClicked)
        )
        
        let button4K = createPresetButton(
            title: Constants.SettingsLabels.preset4K,
            resolution: Constants.Defaults.Resolutions.uhd,
            action: #selector(preset4KClicked)
        )
        
        container.addSubview(button1080p)
        container.addSubview(button1440p)
        container.addSubview(button4K)
        
        NSLayoutConstraint.activate([
            button1080p.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            button1080p.topAnchor.constraint(equalTo: container.topAnchor),
            button1080p.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            
            button1440p.leadingAnchor.constraint(equalTo: button1080p.trailingAnchor, constant: Constants.UI.presetButtonSpacing),
            button1440p.topAnchor.constraint(equalTo: container.topAnchor),
            button1440p.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            
            button4K.leadingAnchor.constraint(equalTo: button1440p.trailingAnchor, constant: Constants.UI.presetButtonSpacing),
            button4K.topAnchor.constraint(equalTo: container.topAnchor),
            button4K.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            button4K.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor),
        ])
        
        return container
    }
    
    private func createStatusSection() -> NSView {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        statusLabel = createLabel(
            text: "",
            fontSize: Constants.Typography.bodySize,
            color: .labelColor
        )
        
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusLabel.topAnchor.constraint(equalTo: view.topAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        return view
    }
    
    // MARK: - Helper Methods for UI Creation
    
    private func createCheckbox(title: String, action: Selector) -> NSButton {
        let checkbox = NSButton(checkboxWithTitle: title, target: self, action: action)
        checkbox.font = NSFont.systemFont(ofSize: Constants.Typography.bodySize)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }
    
    private func createLabel(text: String, fontSize: CGFloat, color: NSColor) -> NSTextField {
        let label = NSTextField(labelWithString: text)
        label.font = NSFont.systemFont(ofSize: fontSize)
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createTextField(placeholder: String) -> NSTextField {
        let textField = NSTextField()
        textField.stringValue = ""
        textField.placeholderString = placeholder
        textField.font = NSFont.systemFont(ofSize: Constants.Typography.bodySize)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.target = self
        textField.action = #selector(resolutionTextChanged)
        return textField
    }
    
    private func createPresetButton(title: String, resolution: (width: Double, height: Double), action: Selector) -> NSButton {
        let button = NSButton(title: title, target: self, action: action)
        button.bezelStyle = .rounded
        button.controlSize = .small
        button.font = NSFont.systemFont(ofSize: Constants.Typography.captionSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // MARK: - Action Methods

    @objc private func launchAtLoginChanged() {
        manager?.launchAtLogin = launchAtLoginCheckbox.state == .on
        manager?.saveSettings()
    }
    
    @objc private func useResolutionFilterChanged() {
        let useFilter = useResolutionFilterCheckbox.state == .on
        
        if useFilter {
            // Enable filtering with default 1080p resolution
            manager?.updateResolutionSettings(
                width: Constants.Defaults.Resolutions.hd.width,
                height: Constants.Defaults.Resolutions.hd.height
            )
        } else {
            // Disable filtering
            manager?.updateResolutionSettings(width: 0, height: 0)
        }
        
        updateUI()
        updateStatusText()
    }
    
    @objc private func resolutionTextChanged() {
        applyResolutionSettings()
    }
    
    @objc private func preset1080pClicked() {
        applyPreset(Constants.Defaults.Resolutions.hd)
    }
    
    @objc private func preset1440pClicked() {
        applyPreset(Constants.Defaults.Resolutions.qhd)
    }
    
    @objc private func preset4KClicked() {
        applyPreset(Constants.Defaults.Resolutions.uhd)
    }
    
    // MARK: - Private Helper Methods
    
    private func applyPreset(_ resolution: (width: Double, height: Double)) {
        useResolutionFilterCheckbox.state = .on
        widthTextField.stringValue = String(Int(resolution.width))
        heightTextField.stringValue = String(Int(resolution.height))
        manager?.updateResolutionSettings(width: resolution.width, height: resolution.height)
        updateUI()
        updateStatusText()
    }
    
    private func applyResolutionSettings() {
        guard let width = Double(widthTextField.stringValue),
              let height = Double(heightTextField.stringValue),
              width > 0, height > 0 else {
            updateUI() // Reset to current values if invalid
            return
        }
        
        manager?.updateResolutionSettings(width: width, height: height)
        updateStatusText()
    }
    
    func updateUI() {
        guard let manager = manager else { return }

        launchAtLoginCheckbox.state = manager.launchAtLogin ? .on : .off

        let useResolutionFilter = manager.minResolutionWidth > 1 && manager.minResolutionHeight > 1
        useResolutionFilterCheckbox.state = useResolutionFilter ? .on : .off

        if useResolutionFilter {
            widthTextField.stringValue = String(Int(manager.minResolutionWidth))
            heightTextField.stringValue = String(Int(manager.minResolutionHeight))
        } else {
            widthTextField.stringValue = Constants.SettingsLabels.widthPlaceholder
            heightTextField.stringValue = Constants.SettingsLabels.heightPlaceholder
        }

        resolutionContainer.isHidden = !useResolutionFilter
        updateStatusText()
    }
    
    private func updateStatusText() {
        guard let manager = manager else { return }

        if !manager.hasAccessibilityPermission {
            statusLabel.stringValue = Constants.StatusMessages.permissionRequired
            statusLabel.textColor = .systemOrange
        } else {
            statusLabel.stringValue = "Toggle dock anytime with ⌘⌥D"
            statusLabel.textColor = .tertiaryLabelColor
        }
    }
}

// MARK: - NSWindowDelegate

extension SettingsWindow: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        manager?.settingsWindow = nil
    }
} 