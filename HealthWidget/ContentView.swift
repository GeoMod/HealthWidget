//
//  ContentView.swift
//  HealthWidget
//
//  Created by Daniel O'Leary on 2/18/21.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var healthManager: HealthKitManager

    var body: some View {
		NavigationView {
			VStack {
				Button(action: {
					healthManager.setUpHealthKitPermissions()
				}, label: {
					Text("Authorize HealthKit")
						.padding()
						.background(Color.purple)
						.foregroundColor(.white)
						.clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
						.shadow(color: .gray, radius: 2, x: 5.0, y: 5.0)
				})

			}
			.navigationTitle("#SwiftUIJam")
			.navigationBarItems(trailing: Image("jam")
									.resizable()
									.scaledToFit()
									.frame(width: 50, height: 50)

			)
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
