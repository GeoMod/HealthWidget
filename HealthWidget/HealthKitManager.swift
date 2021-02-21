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
	let currentDate = Date()

	public func setUpHealthKitPermissions() {
		let authorizationStatus = healthStore.authorizationStatus(for: HKQuantityType.workoutType())
		let typesToShare: Set = [HKQuantityType.workoutType()]

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

		healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
			if success {
				// pull health data
			} else if error != nil {
				// handle erros
			}
		}
	}

	public func updateValues() {
		fetchRestingHeartRate()
		fetchStepCount()
		fetchMaxHeartRate()
		fetchDistance()
	}

	private func fetchMaxHeartRate() {
		let interval = NSDateComponents()
		interval.day = 1

		guard let quantityType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
			fatalError("Unable to retrive heart rate")
		}

		let query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: nil, options: .discreteMax, anchorDate: currentDate, intervalComponents: interval as DateComponents)

		query.initialResultsHandler = { query, results, error in
			guard let statsCollection = results else {
				fatalError("error occurred fetcing resting heart rate")
			}

			let beginningOfDay = self.calendar.dateInterval(of: .day, for: self.currentDate)!.start
			statsCollection.enumerateStatistics(from: beginningOfDay, to: self.currentDate) { statistics, unsafePointer in
				if let quantity = statistics.maximumQuantity() {
					let value = quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
					print("heart RATE is \(value)")
					self.activeHeartRate = Int(value)
				}
			}
		}
		healthStore.execute(query)
	}

	private func fetchRestingHeartRate() {
		let interval = NSDateComponents()
		interval.day = 1

		guard let quantityType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate) else {
			fatalError("Unable to retrive resting heart rate")
		}

		let query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: nil, options: .mostRecent, anchorDate: currentDate, intervalComponents: interval as DateComponents)

		query.initialResultsHandler = { query, results, error in
			guard let statsCollection = results else {
				fatalError("error occurred fetcing resting heart rate")
			}

			let beginningOfDay = self.calendar.dateInterval(of: .day, for: self.currentDate)!.start
			statsCollection.enumerateStatistics(from: beginningOfDay, to: self.currentDate) { statistics, unsafePointer in
				if let quantity = statistics.mostRecentQuantity() {
					let value = quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
					self.restingHeartRate = Int(value)
				}
			}
		}
		healthStore.execute(query)
	}

	private func fetchStepCount() {
		let interval = NSDateComponents()
		interval.day = 1

		guard let quantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
			fatalError("Unable to retrive step count")
		}

		let query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: currentDate, intervalComponents: interval as DateComponents)

		query.initialResultsHandler = { query, results, error in
			guard let statsCollection = results else {
				// Perform proper error handling here
				self.showAlertView()
				fatalError("*** An error occurred while calculating the statistics: \(error?.localizedDescription ?? "Defualt Error") ***")
			}

			guard let beginningOfDay = self.calendar.dateInterval(of: .day, for: self.currentDate)?.start else {
				fatalError("Unable to calculate start date")
			}

			// Plot the step count
			statsCollection.enumerateStatistics(from: beginningOfDay, to: self.currentDate) { statistics, stop in
				if let quantity = statistics.sumQuantity() {
					let value = quantity.doubleValue(for: HKUnit.count())
					// Set the step count
					self.stepCount = Int(value)
				}
			}
		}
		healthStore.execute(query)
	}

	private func fetchDistance() {
		var pastWorkouts = [HKWorkout]()
		let authorizationStatus = healthStore.authorizationStatus(for: HKWorkoutType.workoutType())

		if authorizationStatus != .sharingAuthorized {
			// If the user hasn't authorized HealthKit nothing will happen
			// Consider diplatying a button prompting the user to authorize
			print("App is not authorized")
			return
		}

		let appPredicate = HKQuery.predicateForWorkouts(with: .running)
		let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

		let query = HKSampleQuery(sampleType: .workoutType(), predicate: appPredicate,
								  limit: 2, sortDescriptors: [sortDescriptor]) { query, results, error in
			if let queryError = error {
				print("There was an error \(queryError.localizedDescription)")
			}

			pastWorkouts = results as! [HKWorkout]
			guard pastWorkouts.count != 0 else {
				print("Got nothing")
				return
			}
			self.distance = pastWorkouts[0].totalDistance?.doubleValue(for: HKUnit.mile()) ?? 99.9
//			formatLabel(value: (pastWorkouts[workoutIncrement].totalDistance?.doubleValue(for: HKUnit.mile()))!)

			print("Past workouts are \(pastWorkouts.count) quantitiy")
			print("Most recent workout is \(results![0])")
		}
		healthStore.execute(query)
	}






	// MARK: Error handling
	private func showAlertView() {
		DispatchQueue.main.async {
			self.permissionsError = HealthKitPermissionsError.permissionDenied
		}
	}


}
