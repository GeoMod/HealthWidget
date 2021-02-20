//
//  HealthKitManager.swift
//  HealthWidget
//
//  Created by Daniel O'Leary on 2/19/21.
//

import HealthKit
import Combine

class HealthKitManager: NSObject, ObservableObject  {
	let calendar = Calendar.current

	@Published var permissionsError: LocalizedError?

	@Published var restingHeartRate = 0
	@Published var stepCount = 0
	@Published var activeHeartRate = 0
	@Published var distance = 0.0

	let healthStore = HKHealthStore()

	public func setUpHealthKitPermissions() {
		let authorizationStatus = healthStore.authorizationStatus(for: HKQuantityType.workoutType())


		let typesToRead: Set = [
			HKQuantityType.quantityType(forIdentifier: .heartRate)!,
			HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
			HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
			HKQuantityType.quantityType(forIdentifier: .stepCount)!,
			HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
		]

		if authorizationStatus == .sharingDenied {
			showAlertView()
			return
		}

		healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
			if success {
				// pull health data
			} else if error != nil {
				// handle erros
			}
		}
	}

	public func updateHealthData() {
		fetchRestingHeartRate()
		fetchStepCount()
		fetchActiveHeartRate()
		fetchDistance()
	}


	private func fetchRestingHeartRate() {
		//
	}

	public func fetchStepCount() {
		let interval = NSDateComponents()
		interval.day = 1

		guard let quantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
			fatalError("Unable to retrive step count")
		}
		let query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: Date(), intervalComponents: interval as DateComponents)

		query.initialResultsHandler = { query, results, error in
			guard let statsCollection = results else {
				// Perform proper error handling here
				fatalError("*** An error occurred while calculating the statistics: \(error?.localizedDescription ?? "Defualt Error") ***")
			}

			guard let startDate = self.calendar.date(byAdding: .day, value: -1, to: Date()) else {
				fatalError("Unable to calculate the start date")
			}

			// Plot the weekly step counts over the past 3 months
			statsCollection.enumerateStatistics(from: startDate, to: Date()) { [unowned self] statistics, stop in

				if let quantity = statistics.sumQuantity() {
//					let date = statistics.startDate
					let value = quantity.doubleValue(for: HKUnit.count())

					// Call a custom method to plot each data point.
//					self.plotWeeklyStepCount(value, forDate: date)
					stepCount = Int(value)
				}
			}
		}
		healthStore.execute(query)
	}

	private func fetchActiveHeartRate() {
		guard let quantityType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
			fatalError("Unable to retrive step count")
		}

		//
	}

	private func fetchDistance() {
		//
	}




	// MARK: Error handling
	private func showAlertView() {
		DispatchQueue.main.async {
			self.permissionsError = HealthKitPermissionsError.permissionDenied
		}
	}


}
