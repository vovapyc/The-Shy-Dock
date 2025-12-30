//
//  TheShyDockApp.swift
//  The Shy Dock
//
//  Created by Vova on 2024-09-06.
//

import SwiftUI

@main
struct TheShyDockApp: App {
    @StateObject private var menuBarManager = MenuBarManager()
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
