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

	let manager = HealthKitManager()

	func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(date: Date(), restingHeartRate: 55, stepCount: 2000, activeHeartRate: 134, distance: 3.3)
	}

	func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		let entry = SimpleEntry(date: Date(), restingHeartRate: 55, stepCount: 2000, activeHeartRate: 134, distance: 3.3)
		completion(entry)
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
		var entries: [SimpleEntry] = []

		// Generate a timeline consisting of 1 entry an hour in the past, starting from the current date.
		let currentDate = Date()

		fetchHealthData()

		for hourOffset in 0 ..< 2 {
			let entryDate = Calendar.current.date(byAdding: .hour, value: -hourOffset, to: currentDate)!
			let entry = SimpleEntry(date: entryDate, restingHeartRate: 55, stepCount: manager.stepCount, activeHeartRate: manager.activeHeartRate, distance: 3.3)
			entries.append(entry)
		}

		let timeline = Timeline(entries: entries, policy: .atEnd)
		completion(timeline)
	}


	private func fetchHealthData() {
		manager.updateHealthData()
	}


}
