//
//  ScheduleStore.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/5/24.
//

import Foundation

@MainActor
class ScheduleStore: ObservableObject {
  @Published var scheduleData: ScheduleData?
  @Published var isLoading = false

  private let scheduleCacheKey = "scheduleCache"
  private let cacheExpirationKey = "cacheExpiration"
  private let scheduleURL = "https://splatoon3.ink/data/schedules.json"
  private let gearURL = "https://splatoon3.ink/data/gear.json"
  private let coopURL = "https://splatoon3.ink/data/coop.json"
  private let splatfestURL = "https://splatoon3.ink/data/festivals.json"

  var nextHourDate: Date {
    let calendar = Calendar.current
    let now = Date()
    var components = calendar.dateComponents([.year, .month, .day, .hour], from: now)

    components.hour! += 1
    components.minute = 0
    components.second = 0

    return calendar.date(from: components) ?? now
  }

  func cacheScheduleData(_ scheduleData: ScheduleData) {
    if let encodedData = try? JSONEncoder().encode(scheduleData) {
      UserDefaults.standard.set(encodedData, forKey: scheduleCacheKey)
      let expirationDate = nextHourDate
      UserDefaults.standard.set(expirationDate, forKey: cacheExpirationKey)
    }
  }

  func fetchScheduleDataIfNeeded() async {
    guard isCacheExpired() else {
      if let scheduleData = getCachedScheduleData() {
        self.scheduleData = scheduleData
        return
      }
      return
    }

    await fetchScheduleData()
  }

  func getCachedScheduleData() -> ScheduleData? {
    guard let data = UserDefaults.standard.data(forKey: scheduleCacheKey) else {
      return nil
    }
    let scheduleData = try? JSONDecoder().decode(ScheduleData.self, from: data)
    return scheduleData
  }

  func isCacheExpired() -> Bool {
    if let expirationDate = UserDefaults.standard.object(forKey: cacheExpirationKey) as? Date {
      return Date() > expirationDate
    }
    return true
  }

  func fetchScheduleData() async {
    guard let url = URL(string: scheduleURL) else {
      print("Invalid URL.")
      return
    }
    isLoading = true

    do {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      let (data, response) = try await URLSession.shared.data(from: url)

      // Check for HTTP response errors or status codes here.
      if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
        print("HTTP Error: Status code \(httpResponse.statusCode)")
        print("HTTP Response: \(httpResponse)")
      }

      // Attempt to decode the JSON data to your ScheduleData model.
      let schedule = try decoder.decode(ScheduleData.self, from: data)
      await MainActor.run {
        self.scheduleData = schedule
        self.isLoading = false
        cacheScheduleData(schedule)
      }
    } catch let DecodingError.dataCorrupted(context) {
      await MainActor.run { self.isLoading = false }
      print("Data corrupted: \(context.debugDescription)")
    } catch let DecodingError.keyNotFound(key, context) {
      await MainActor.run { self.isLoading = false }
      print("Key '\(key)' not found in JSON: \(context.debugDescription)")
      print("Coding Path: \(context.codingPath)")
    } catch let DecodingError.valueNotFound(value, context) {
      await MainActor.run { self.isLoading = false }
      print("Value '\(value)' not found: \(context.debugDescription)")
      print("Coding Path: \(context.codingPath)")
    } catch let DecodingError.typeMismatch(type, context) {
      await MainActor.run { self.isLoading = false }
      print("Type '\(type)' mismatch: \(context.debugDescription)")
      print("Coding Path: \(context.codingPath)")
    } catch {
      await MainActor.run { self.isLoading = false }
      print("Unexpected error: \(error.localizedDescription)")
    }
  }

  func formatTime(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "HH:mm a"

    let timeStringWithAMPM = formatter.string(from: date)
    let customizedTimeString = timeStringWithAMPM
      .replacingOccurrences(of: "AM", with: "a.m.")
      .replacingOccurrences(of: "PM", with: "p.m.")
    return customizedTimeString
  }

  func formatDateTime(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "M/d h:mm a"
    formatter.amSymbol = "a.m."
    formatter.pmSymbol = "p.m."
    return formatter.string(from: date)
  }

  func getRegularSchedules() -> [BankaraSchedulesNode]? {
    return scheduleData?.data.regularSchedules.nodes
  }

  func getBankaraSchedules() -> [BankaraSchedulesNode]? {
    return scheduleData?.data.bankaraSchedules.nodes
  }

  func getXSchedules() -> [BankaraSchedulesNode]? {
    return scheduleData?.data.xSchedules.nodes
  }

  func getEventSchedules() -> [EventSchedulesNode]? {
    return scheduleData?.data.eventSchedules.nodes
  }

//  func getFestSchedules() -> [BankaraSchedulesNode]? {
//    return scheduleData?.data.festSchedules.nodes
//  }

  func getCoopGroupingSchedules() -> [PurpleNode]? {
    return scheduleData?.data.coopGroupingSchedule.regularSchedules.nodes
  }

  func getStages() -> [VsStagesNode]? {
    return scheduleData?.data.vsStages.nodes
  }
}


// MARK: - Extensions
extension ScheduleStore {
  static let shared = ScheduleStore()
}
