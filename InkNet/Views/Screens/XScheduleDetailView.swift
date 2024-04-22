//
//  XBattleScheduleView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/21/24.
//

import SwiftUI

struct XScheduleDetailView: View {
  @EnvironmentObject var scheduleStore: ScheduleStore
  @State private var showReminderView = false
  @State private var selectedImageUrl: URL?
  @State private var selectedStageName: String?

  var body: some View {
    NavigationStack {
      ZStack {
        backgroundImageView
        xBattleScheduleContent
        overlayView
      }
      .toolbar {
        ToolbarItemGroup(placement: .principal) {
          HStack {
            Image("x")
            ShadedSplatoon1Text(text: "X Battle", size: 24.0)
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

  private var xBattleScheduleContent: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: -4) {
        if let xSchedules = scheduleStore.getXSchedules() {
          ForEach(xSchedules, id: \.startTime) { schedule in
            xBattleScheduleDetailView(for: schedule)
          }
        } else {
          Text("No X Battle schedules available.")
            .foregroundColor(.gray)
            .padding()
        }
      }
      .padding(.horizontal)
    }
  }

  private func xBattleScheduleDetailView(for schedule: BankaraSchedulesNode) -> some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(scheduleStore.formatDateTime(from: schedule.startTime))
        .font(.custom("Splatoon1", size: 12.0))
        .padding(.horizontal)
        .foregroundColor(.black)
        .background(Color("XRankTeal"))
        .clipShape(RoundedRectangle(cornerRadius: 25.0))

      if let xMatchSetting = schedule.xMatchSetting {
        VStack(alignment: .leading, spacing: 0) {
          HStack {
            Image(xMatchSetting.vsRule.rule.rawValue.lowercased())
              .scaleEffect(0.8)
            ShadedSplatoon1Text(text: xMatchSetting.vsRule.name.rawValue, size: 20.0)
          }
          StageView(stages: xMatchSetting.vsStages) { url, name in
            self.selectedImageUrl = url
            self.selectedStageName = name
          }
        }
      } else {
        Text("Details unavailable")
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
  XScheduleDetailView()
    .environmentObject(ScheduleStore())
}
