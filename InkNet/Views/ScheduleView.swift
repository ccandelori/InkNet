//
//  ScheduleView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/5/24.
//

import SwiftUI

struct ScheduleView: View {
  @StateObject var scheduleStore = ScheduleStore()

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 10) {
          if let turfWar = scheduleStore.getRegularSchedules() {
            ForEach(turfWar, id: \.startTime) { schedule in
              Text(scheduleStore.formatTime(from: schedule.startTime))
                .font(.custom("Splatoon1", size: 12.0))
                .padding(.horizontal)
                .background(.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))

              StageView(stages: schedule.regularMatchSetting!.vsStages)
            }
          }
        }
        .padding(.horizontal)
      }
      .toolbar  {
        ToolbarItem(placement: .principal) {
          VStack {
            Text("Turf War")
              .font(.custom("Splatoon1", size: 24.0))
          }
        }
      }
      .listStyle(.plain)
    }
    .onAppear {
      Task {
        await scheduleStore.fetchScheduleDataIfNeeded()
      }
    }
  }
}

#Preview {
  ScheduleView()
}
