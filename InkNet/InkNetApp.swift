//
//  InkNetApp.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/5/24.
//

import SwiftUI

@main
struct InkNetApp: App {
  @StateObject var scheduleStore = ScheduleStore()
  @StateObject var notificationManager = NotificationManager(scheduleStore: ScheduleStore())
  @State private var isSplashScreenActive = true

  init() {
    let store = ScheduleStore()
    _scheduleStore = StateObject(wrappedValue: store)
    _notificationManager = StateObject(wrappedValue: NotificationManager(scheduleStore: store))
  }

  var body: some Scene {
    WindowGroup {
      if isSplashScreenActive {
        SplashScreenView(isPresented: $isSplashScreenActive)
      } else {
        MainAppView()
          .environmentObject(scheduleStore)
          .environmentObject(notificationManager)
          .onAppear {
            Task {
              let granted = try await notificationManager.requestAuthorization()
              print("Notifications granted: \(granted)")
            }
          }
      }
    }
  }
}
