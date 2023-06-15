//
//  ContentView.swift
//  SimpleBeaconApp
//
//  Created by Tomas Babulak on 07.06.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = ContentObservableObject()

    var body: some View {
        VStack(spacing: 40) {
            VStack {
                Text("Enter iBeacon UUID")
                TextField("01122334-4556-6778-899A-ABBCCDDEEFF0", text: model.enteredUUID)
            }
            VStack {
                Text("iBeacon UUID")
                Text(model.beaconId?.uuidString ?? "You must enter your iBeacon UUID first!")
            }

            Button(
                action: { model.setBeaconNotification() },
                label: { Text("Setup Notifications") }
            )

            Spacer()

            VStack {
                Text("Pending Notifications")
                ScrollView {
                    Text(String(describing: model.pendingNotifications))
                }.frame(maxHeight: 200)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
