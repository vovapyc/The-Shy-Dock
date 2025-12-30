//
//  DockAwayApp.swift
//  DockAway
//
//  Created by Vova on 2024-09-06.
//

import SwiftUI

@main
struct DockAwayApp: App {
    @StateObject private var menuBarManager = MenuBarManager()
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
