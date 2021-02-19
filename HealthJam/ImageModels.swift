//
//  ImageModels.swift
//  HealthJamExtension
//
//  Created by Daniel O'Leary on 2/19/21.
//

import SwiftUI

enum SFSymbolImage: String, View {
	case activeHeartrate 	= "bolt.heart.fill"
	case calories 			= "bolt.horizontal.fill"
	case distance 			= "chevron.right.circle.fill"
	case restingHeartRate 	= "heart.fill"
	case stepcount 			= "figure.walk.circle.fill"

	var body: some View {
		Image(systemName: rawValue)
	}
}


struct FootnoteModifer: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.footnote)
			.foregroundColor(.gray)
			.opacity(0.7)
	}
}
