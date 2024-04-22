//
//  AnarchyScheduleDetailView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/21/24.
//

import SwiftUI

struct AnarchyScheduleDetailView: View {
  @EnvironmentObject var scheduleStore: ScheduleStore
  @State private var selectedImageUrl: URL?
  @State private var selectedStageName: String?
  @State private var showReminderView = false

  var body: some View {
    NavigationStack {
      ZStack {
        backgroundImageView
        scrollViewContent
        overlayView
      }
      .toolbar {
        ToolbarItemGroup(placement: .principal) {
          HStack {
            Image("bankara")
            ShadedSplatoon1Text(text: "Anarchy Battle", size: 24.0)
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            showReminderView = true
          } label: {
            Image("little-buddy")
              .resizable()
              .frame(width: 30, height: 34)
              .padding()
          }
          .sheet(isPresented: $showReminderView) {
            ReminderView()
          }
        }
      }
    }
  }

  private var backgroundImageView: some View {
    Image("bg-light")
      .resizable()
      .ignoresSafeArea(.all)
      .opacity(0.2)
      .scaleEffect(CGSize(width: 2.33, height: 1.33))
  }

  private var scrollViewContent: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: -4) {
        if let anarchyBattles = scheduleStore.getBankaraSchedules() {
          ForEach(anarchyBattles, id: \.startTime) { schedule in
            scheduleDetailView(for: schedule)
          }
        }
      }
      .padding(.horizontal)
    }
  }

  private func scheduleDetailView(for schedule: BankaraSchedulesNode) -> some View {
    VStack(alignment: .leading, spacing: 0) {
      ShadedSplatoon1Text(text: scheduleStore.formatTime(from: schedule.startTime), size: 12.0)
        .padding(.horizontal)
        .background(Color("AnarchyOrange"))
        .clipShape(RoundedRectangle(cornerRadius: 25.0))

      if let matchSettings = schedule.bankaraMatchSettings, !matchSettings.isEmpty {
        ForEach(matchSettings, id: \.bankaraMode) { setting in
          VStack(alignment: .leading, spacing: 0) {
            HStack {
              Image(setting.vsRule.rule.rawValue.lowercased())
                .scaleEffect(0.8)
              ShadedSplatoon1Text(text: setting.vsRule.name.rawValue, size: 20.0)
              ShadedSplatoon2Text(text: setting.bankaraMode!.rawValue, size: 14.0)
                .padding(.horizontal)
                .background(Color("AccentPurple"))
                .foregroundColor(.white)
                .rotationEffect(.degrees(0))
            }
            StageView(stages: setting.vsStages) { url, name in
              self.selectedImageUrl = url
              self.selectedStageName = name
            }
          }
        }
      } else {
        Text("No match information available")
          .padding()
          .foregroundColor(.gray)
      }
    }
  }


  private var overlayView: some View {
    Group {
      if let url = selectedImageUrl, let name = selectedStageName {
        FullImageView(url: url, stageName: name) {
          self.selectedImageUrl = nil
          self.selectedStageName = nil
        }
      }
    }
  }
}

#Preview {
  AnarchyScheduleDetailView()
    .environmentObject(ScheduleStore())
}
