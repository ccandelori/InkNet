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
      Text(scheduleStore.formatTime(from: schedule.startTime))
        .font(.custom("Splatoon1", size: 12.0))
        .padding(.horizontal)
        .foregroundColor(.black)
        .background(Color("AnarchyOrange"))
        .clipShape(RoundedRectangle(cornerRadius: 25.0))

      // Check if there are match settings and iterate over each to create a StageView for each match setting
      if let matchSettings = schedule.bankaraMatchSettings, !matchSettings.isEmpty {
        ForEach(matchSettings, id: \.bankaraMode) { setting in
          StageView(stages: setting.vsStages) { url, name in
            self.selectedImageUrl = url
            self.selectedStageName = name
          }
        }
      } else {
        Text("No match settings available")
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
