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
	func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(date: Date(), restingHeartRate: 55, stepCount: 2000, activeHeartRate: 104, distance: 3.3)
	}

	func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		let entry = SimpleEntry(date: Date(), restingHeartRate: 55, stepCount: 2000, activeHeartRate: 104, distance: 3.3)
		completion(entry)
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
		var entries: [SimpleEntry] = []

		// Generate a timeline consisting of five entries an hour apart, starting from the current date.
		let currentDate = Date()
		for hourOffset in 0 ..< 5 {
			let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
			let entry = SimpleEntry(date: entryDate, restingHeartRate: 55, stepCount: 2000, activeHeartRate: 104, distance: 3.3)
			entries.append(entry)
		}

		let timeline = Timeline(entries: entries, policy: .atEnd)
		completion(timeline)
	}
}
