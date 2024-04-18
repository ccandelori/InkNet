//
//  NotificationManager.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/16/24.
//

import Foundation
import Combine
import UserNotifications

@MainActor
class NotificationManager: ObservableObject {
  var scheduleStoreSubscription: AnyCancellable?
  var scheduleStore: ScheduleStore

  init(scheduleStore: ScheduleStore) {
    self.scheduleStore = scheduleStore
    scheduleStoreSubscription = scheduleStore.$scheduleData
      .receive(on: RunLoop.main)
      .sink { [weak self] scheduleData in
        self?.processScheduleData(scheduleData)
      }
  }

  // Process new schedule data
  private func processScheduleData(_ scheduleData: ScheduleData?) {
    guard let data = scheduleData else { return }
    scheduleNotificationsForPreferredStages(scheduleData: data)
  }

  // Requests authorization for notifications
  func requestAuthorization() async throws -> Bool {
    return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
  }

  // Setup notifications based on user's preferences and schedule data
  func scheduleNotificationsForPreferredStages(scheduleData: ScheduleData) {
    // Fetch user's preferred stages from UserDefaults
    let selectedStages = UserDefaults.standard.array(forKey: "selectedRegularStages") as? [String] ?? []

    // Iterate over each node in the regular schedules
    for scheduleNode in scheduleData.data.regularSchedules.nodes {
      // Check if the regularMatchSetting contains any of the user's preferred stages
      if let matchSetting = scheduleNode.regularMatchSetting,
         let vsStages = matchSetting.vsStages.first(where: { vsStage in selectedStages.contains(vsStage.name) }) {
        // If a preferred stage is found, schedule the notifications
        scheduleNotification(stageName: vsStages.name, startTime: scheduleNode.startTime, type: "reminder")
        scheduleNotification(stageName: vsStages.name, startTime: scheduleNode.startTime, type: "start")
      }
    }
  }

  func scheduleNotification(stageName: String, startTime: Date, type: String) {
    let content = UNMutableNotificationContent()
    content.title = "Upcoming Match!"
    content.body = "Your preferred stage \(stageName) is about to start."
    content.sound = UNNotificationSound.default

    var notificationTime = startTime
    if type == "reminder" {
      notificationTime = Calendar.current.date(byAdding: .minute, value: -15, to: startTime) ?? startTime
      content.body = "Your preferred stage \(stageName) will start in 15 minutes."
    }

    let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationTime)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        print("Error scheduling notification: \(error.localizedDescription)")
      }
    }
  }

}
