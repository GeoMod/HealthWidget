//
//  HealthJam.swift
//  HealthJam
//
//  Created by Daniel O'Leary on 2/19/21.
//

import WidgetKit
import SwiftUI

enum SFSymbolImage: String, View {
	case activeHeartrate = "bolt.heart.fill"
	case calories = "bolt.horizontal.fill"
	case distance = "chevron.right.circle.fill"
	case restingHeartRate = "heart.fill"
	case stepcount = "figure.walk.circle.fill"

	var body: some View {
		Image(systemName: rawValue)
	}
}


struct HealthJamEntryView : View {
	var entry: Provider.Entry

	var body: some View {
		ZStack {
			Color("WidgetBackground")
			VStack(alignment: .leading) {
				Text(entry.date, style: .date)
					.font(Font.title2.bold())
					.padding(.leading)

				HStack(alignment: .top) {
					Image(systemName: "waveform.path.ecg")
						.font(.largeTitle)
						.foregroundColor(.red)
						.padding([.leading, .trailing])
					Spacer()
					HeatlthMetricsView()
						.font(Font.body.monospacedDigit())
						.padding()
				}
			}
			.foregroundColor(.white)
		}
	}

}


struct HeatlthMetricsView: View {
	var body: some View {
		VStack(alignment: .leading, spacing: 2) {
			Label {
				Text("Resting Heart Rate")
			} icon: {
				SFSymbolImage.restingHeartRate
					.foregroundColor(.purple)
			}

			Label {
				Text("Step Count")
			} icon: {
				SFSymbolImage.stepcount
					.foregroundColor(.blue)
			}

			Label {
				Text("Active Heart Rate")
			} icon: {
				SFSymbolImage.activeHeartrate
					.foregroundColor(.red)
			}

			Label {
				Text("Run/Walk Distance")
			} icon: {
				SFSymbolImage.distance
					.foregroundColor(.green)
			}
		}
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
		HealthJamEntryView(entry: SimpleEntry(date: Date(), heart: Image(systemName: "heart.fill")))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
