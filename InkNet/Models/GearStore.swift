//
//  GearStore.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/19/24.
//

import Foundation

@MainActor
class GearStore: ObservableObject {
  @Published var gearData: GearData?
  @Published var isLoading = false

  private let gearURL = "https://splatoon3.ink/data/gear.json"
  private let cacheKey = "gearCache"
  private let cacheExpirationKey = "gearCacheExpiration"

  var nextHourDate: Date {
    let calendar = Calendar.current
    let now = Date()
    var components = calendar.dateComponents([.year, .month, .day, .hour], from: now)

    components.hour! += 1
    components.minute = 0
    components.second = 0

    return calendar.date(from: components) ?? now
  }

  func fetchGearDataIfNeeded() async {
    guard let url = URL(string: gearURL) else {
      print("Invalid URL")
      return
    }

    isLoading = true
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .custom { decoder in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
          return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(dateString)")
      }

      self.gearData = try decoder.decode(GearData.self, from: data)
    } catch {
      print("Error fetching gear data: \(error)")
    }
    isLoading = false
  }

  private func fetchGearData() async {
    isLoading = true
    guard let url = URL(string: gearURL) else {
      isLoading = false
      return
    }

    do {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      let (data, response) = try await URLSession.shared.data(from: url)

      if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
        print("HTTP Error: Status code \(httpResponse.statusCode)")
        print("HTTP Response: \(httpResponse)")
      }

      let decodedData = try JSONDecoder().decode(GearData.self, from: data)
      await MainActor.run {
        self.gearData = decodedData
        self.cacheGearData(decodedData)
        self.isLoading = false
      }
    } catch {
      await MainActor.run {
        self.isLoading = false
        print("Error fetching gear data: \(error)")
      }
    }
  }

  private func cacheGearData(_ gearData: GearData) {
    do {
      let data = try JSONEncoder().encode(gearData)
      UserDefaults.standard.set(data, forKey: cacheKey)
      UserDefaults.standard.set(Date().addingTimeInterval(3600), forKey: cacheExpirationKey)
    } catch {
      print("Failed to cache gear data: \(error)")
    }
  }

  private func getCachedGearData() -> GearData? {
    guard let data = UserDefaults.standard.data(forKey: cacheKey) else {
      return nil
    }
    return try? JSONDecoder().decode(GearData.self, from: data)
  }

  private func isCacheExpired() -> Bool {
    guard let expirationDate = UserDefaults.standard.object(forKey: cacheExpirationKey) as? Date else {
      return true
    }
    return Date() > expirationDate
  }
}
