//
//  ContentView.swift
//  HealthWidget
//
//  Created by Daniel O'Leary on 2/18/21.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
	@EnvironmentObject var healthManager: HealthKitManager

    var body: some View {
		NavigationView {
			VStack {
				Label("Ensure you have Authorized HealthKit by pressing the button below. Then install the “HealthJam” Widget to view historical health data on your home screen.", systemImage: "heart.text.square.fill")
					.labelsHidden()
					.font(.title3)
					.padding()
				Spacer()
				Button(action: {
					healthManager.setUpHealthKitPermissions()
				}, label: {
					Text("Authorize HealthKit")
						.padding()
						.background(Color.purple)
						.foregroundColor(.white)
						.font(.headline)
						.clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
						.shadow(color: .gray, radius: 2, x: 5.0, y: 5.0)
				})

				Spacer()
			}
			.navigationTitle("#SwiftUIJam")
			.navigationBarItems(trailing: Button(action: {
				WidgetCenter.shared.reloadAllTimelines()
			}, label: {
				Image("jam")
					.resizable()
					.scaledToFit()
					.frame(width: 50, height: 50)
					.shadow(radius: 10)
			})

			)
		}
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
