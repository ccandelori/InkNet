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

  private func processScheduleData(_ scheduleData: ScheduleData?) {
    guard let data = scheduleData else { return }
    scheduleNotificationsForPreferredStages(scheduleData: data)
  }

  func requestAuthorization() async throws -> Bool {
    return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
  }

  func scheduleNotificationsForPreferredStages(scheduleData: ScheduleData) {
    let selectedStages = UserDefaults.standard.array(forKey: "selectedRegularStages") as? [String] ?? []

    for scheduleNode in scheduleData.data.regularSchedules.nodes {
      if let matchSetting = scheduleNode.regularMatchSetting,
         let vsStages = matchSetting.vsStages.first(where: { vsStage in selectedStages.contains(vsStage.name) }) {
        scheduleNotification(stageName: vsStages.name, startTime: scheduleNode.startTime, type: "reminder")
        scheduleNotification(stageName: vsStages.name, startTime: scheduleNode.startTime, type: "start")
      }
    }
  }

  func scheduleNotification(stageName: String, startTime: Date, type: String) {
    let content = UNMutableNotificationContent()
    content.title = "Upcoming Match!"
    content.body = "\(stageName) is in the current rotation!"
    content.sound = UNNotificationSound.default

    var notificationTime = startTime
    if type == "reminder" {
      notificationTime = Calendar.current.date(byAdding: .minute, value: -15, to: startTime) ?? startTime
      content.body = "\(stageName) will be in the next rotation, starting in 15 minutes!"
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
