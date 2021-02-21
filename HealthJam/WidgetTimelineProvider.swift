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

//		for offset in 0 ..< 3 {
//			let entryDate = calendar.date(byAdding: .minute, value: offset, to: Date())!
//			let entry = SimpleEntry(date: entryDate, restingHeartRate: manager.restingHeartRate, stepCount: manager.stepCount, activeHeartRate: manager.activeHeartRate, distance: manager.distance)
//			entries.append(entry)
//		}

		let refreshDate = calendar.date(byAdding: .minute, value: 30, to: Date())!
		let entry = SimpleEntry(date: Date(), restingHeartRate: manager.restingHeartRate, stepCount: manager.stepCount, activeHeartRate: manager.activeHeartRate, distance: manager.distance)
		entries.append(entry)

//		let timeline = Timeline(entries: entries, policy: .atEnd)
		let timeline = Timeline(entries: entries, policy: .after(refreshDate))
		completion(timeline)
	}




}
