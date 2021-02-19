//
//  HealthJam.swift
//  HealthJam
//
//  Created by Daniel O'Leary on 2/19/21.
//

import WidgetKit
import SwiftUI


struct HealthJamEntryView : View {
	var entry: Provider.Entry

	var body: some View {
		ZStack {
			Color("WidgetBackground")
			VStack(alignment: .leading) {
				Text(entry.date, style: .date)
					.font(Font.title2.bold())
					.padding(.bottom)
				HStack(alignment: .top) {
					Image(systemName: "waveform.path.ecg")
						.font(.largeTitle)
						.foregroundColor(.red)
						.padding([.leading, .trailing])
					HeatlthMetricsView(entry: entry)
						.font(Font.body.monospacedDigit())
				}
			}
			.foregroundColor(.white)
		}
	}
}


struct HeatlthMetricsView: View {
	var entry: Provider.Entry

	var body: some View {
		HStack(spacing: 10) {
			VStack(alignment: .leading, spacing: 5) {
				Label {
					VStack(alignment: .leading) {
						Text("\(entry.restingHeartRate)")
						Text("Resting HR")
							.modifier(FootnoteModifer())
					}
				} icon: {
					SFSymbolImage.restingHeartRate
						.foregroundColor(.purple)
				}

				Label {
					VStack(alignment: .leading) {
						Text("\(entry.stepCount)")
						Text("Step Count")
							.modifier(FootnoteModifer())
					}
				} icon: {
					SFSymbolImage.stepcount
						.foregroundColor(.blue)
				}
			}

			VStack(alignment: .leading, spacing: 5) {
				Label {
					VStack(alignment: .leading) {
						Text("\(entry.activeHeartRate)")
						Text("Active HR")
							.modifier(FootnoteModifer())
					}
				} icon: {
					SFSymbolImage.activeHeartrate
						.foregroundColor(.red)
				}

				Label {
					VStack(alignment: .leading) {
						Text("\(entry.distance, specifier: "%.2f")")
						Text("Distance")
							.modifier(FootnoteModifer())
					}
				} icon: {
					SFSymbolImage.distance
						.foregroundColor(.green)
				}
			}
		}.padding(.bottom)
	}



}


@main
struct HealthJam: Widget {
    let kind: String = "HealthJam"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HealthJamEntryView(entry: entry)
        }
        .configurationDisplayName("HealthJam")
        .description("A Widget displaying historical Health Data.")
		.supportedFamilies([.systemMedium])

    }
}

struct HealthJam_Previews: PreviewProvider {
    static var previews: some View {
		HealthJamEntryView(entry: SimpleEntry(date: Date(), restingHeartRate: 55, stepCount: 2000, activeHeartRate: 104, distance: 3.3))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
