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
        VStack {
            Button(
                action: { model.setBeaconNotification() },
                label: { Text("Setup Notifications") }
            )
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
