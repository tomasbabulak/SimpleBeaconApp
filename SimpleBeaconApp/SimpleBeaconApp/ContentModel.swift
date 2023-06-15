//
//  ContentModel.swift
//  SimpleBeaconApp
//
//  Created by Tomas Babulak on 07.06.2023.
//

import Foundation
import SwiftUI
import UIKit
import CoreLocation

class ContentObservableObject: NSObject, ObservableObject {
    let locationManager: CLLocationManager = CLLocationManager()
    let center = UNUserNotificationCenter.current()
    @Published var beaconId: UUID? // = UUID(uuidString: "01122334-4556-6778-899A-ABBCCDDEEFF0") // You can initialize uuid here also

    @Published var pendingNotifications: String? = nil

    var helperUUIDString: String = ""
    var enteredUUID: Binding<String> {
        Binding(
            get: { self.helperUUIDString },
            set: {
                self.helperUUIDString = $0
                self.beaconId = UUID(uuidString: $0)
            }
        )
    }

    override init() {
        super.init()
        requestNotifications()
        requestLocationServices()

        // see, if there are some pending notifications
        updatePendingNotifications()
    }

    func requestNotifications() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func requestLocationServices() {
        locationManager.requestWhenInUseAuthorization()
    }

    func setBeaconNotification() {
        guard let beaconId else {
            assertionFailure("You did not set iBeacon UUID")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Beacon detected!"
        content.sound = UNNotificationSound.default

        let constraint = CLBeaconIdentityConstraint(uuid: beaconId)
        let region = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: UUID().uuidString)
        region.notifyOnEntry = true
        region.notifyOnExit = true

        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        center.add(request)

        // update pending notifications
        updatePendingNotifications()
    }

    func updatePendingNotifications() {
        center.getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                self.pendingNotifications = requests.description
            }
        }
    }
}

extension ContentObservableObject: UNUserNotificationCenterDelegate {
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.

        completionHandler([.alert, .badge, .sound])
    }

    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
