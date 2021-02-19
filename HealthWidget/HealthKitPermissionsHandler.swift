//
//  HealthKitPermissionsHandler.swift
//  HealthWidget
//
//  Created by Daniel O'Leary on 2/19/21.
//

import SwiftUI
//import Foundation

enum HealthKitPermissionsError: LocalizedError {
	case permissionDenied

	var errorDescription: String? {
		switch self {
			case .permissionDenied:
				return "Health Data Access Restricted"
		}
	}

	var failureReason: String? {
		switch self {
			case .permissionDenied:
				return "Permission Denied"
		}
	}

	var recoverySuggestion: String? {
		switch self {
			case .permissionDenied:
				return "Go to Settings > Health > Data Access & Devices to allow Run Roster to access the Health app in order to update workout metrics."
		}
	}
}

// Adapted from: https://augmentedcode.io/2020/03/01/alert-and-localizederror-in-swiftui/
// Does not allow casting `as NSError`
extension Alert {
	init(localizedError: LocalizedError, handler: (() -> Void)?) {
		let message = [localizedError.errorDescription,
					   localizedError.recoverySuggestion].compactMap { $0 }.joined(separator: "\n\n")
		self = Alert(title: Text(localizedError.failureReason!), message: Text(message), dismissButton: .default(Text("OK"), action: handler) )
	}
}
