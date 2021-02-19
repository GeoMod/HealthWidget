//
//  HealthKitManager.swift
//  HealthWidget
//
//  Created by Daniel O'Leary on 2/19/21.
//

import HealthKit
import Combine

class HealthKitManager: NSObject, ObservableObject  {

	@Published var permissionsError: LocalizedError?


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


	// MARK: Error handling
	private func showAlertView() {
		DispatchQueue.main.async {
			self.permissionsError = HealthKitPermissionsError.permissionDenied
		}
	}


}
