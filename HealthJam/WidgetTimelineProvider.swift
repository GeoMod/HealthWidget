//
//  WidgetTimelineProvider.swift
//  HealthJamExtension
//
//  Created by Daniel O'Leary on 2/19/21.
//

import SwiftUI
import WidgetKit

struct SimpleEntry: TimelineEntry {
	let date: Date
	let restingHeartRate: Int
	let stepCount: Int
	let activeHeartRate: Int
	let distance: Double
}

struct Provider: TimelineProvider {
	let calendar = Calendar.current

//	let manager = HealthKitManager()

	@ObservedObject var manager: HealthKitManager

	func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(date: Date(), restingHeartRate: 55, stepCount: 2000, activeHeartRate: 134, distance: 3.3)
	}

	func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		let entry = SimpleEntry(date: Date(), restingHeartRate: 55, stepCount: 2000, activeHeartRate: 134, distance: 3.3)
		completion(entry)
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
		var entries: [SimpleEntry] = []
		print("updating")

		manager.updateValues()

		#warning("First fetch returns 0's for everything, then the next one updates to proper values in the timeline/widget")
		for _ in 0 ..< 2 {
			let entryDate = Calendar.current.date(byAdding: .second, value: -30, to: Date())!
			let entry = SimpleEntry(date: entryDate, restingHeartRate: manager.restingHeartRate, stepCount: manager.stepCount, activeHeartRate: manager.activeHeartRate, distance: manager.distance)
			entries.append(entry)
		}
		let timeline = Timeline(entries: entries, policy: .atEnd)
		completion(timeline)
	}


}
