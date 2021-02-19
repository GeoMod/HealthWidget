//
//  HealthWidgetApp.swift
//  HealthWidget
//
//  Created by Daniel O'Leary on 2/18/21.
//

import SwiftUI

@main
struct HealthWidgetApp: App {
	let healthPermissionsManager = HealthKitManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(healthPermissionsManager)
        }
    }
}
