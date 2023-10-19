//
//  TestingPracticeApp.swift
//  TestingPractice
//
//  Created by NH on 9/11/23.
//

import SwiftUI

@main
struct TestingPracticeApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                PeopleView()
                    .tabItem {
                        Symbols.person
                        Text("Home")
                }
                SettingsView()
                    .tabItem {
                        Symbols.gear
                        Text("Settings")
                    }
            }
        }
    }
}

// Structure of your app
// base - accessed by everyone
// ///////Views -- shared across multiple features
// resources - all files related to resources
// features -> component of app (like list of people, create, settings)
// ///////People -> views, models, viewModels
// ///////Create --> views, models, viewModels
// ///////Settings --> views (doesn't need a VM because it doesn't interact with a service)
//

