//
//  ScheduleView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/5/24.
//

import SwiftUI

struct RegularScheduleDetailView: View {
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
            Image("regular")
            ShadedSplatoon1Text(text: "Turf War", size: 24.0)
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
              .foregroundColor(Color("TurfWarGreen"))
          }
          .sheet(isPresented: $showReminderView) {
            ReminderView()
          }
        }
      }
      .onAppear {
        Task {
          await scheduleStore.fetchScheduleDataIfNeeded()
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
        if let turfWar = scheduleStore.getRegularSchedules() {
          ForEach(turfWar, id: \.startTime) { schedule in
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
        .background(Color("TurfWarGreen"))
        .clipShape(RoundedRectangle(cornerRadius: 25.0))

      // Handle optional `regularMatchSetting` and `vsStages`
      if let stages = schedule.regularMatchSetting?.vsStages {
        StageView(stages: stages) { url, name in
          self.selectedImageUrl = url
          self.selectedStageName = name
        }
      } else {
        // Provide an alternative view or handling if `vsStages` is nil
        Text("No stages available")
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

struct FullImageView: View {
  let url: URL
  let stageName: String
  let onDismiss: () -> Void

  var body: some View {
    Color.black.opacity(0.5)
      .edgesIgnoringSafeArea(.all)
    ZStack(alignment: .bottom) {
      ZStack(alignment: .topTrailing) {
        AsyncImage(url: url) { image in
          image
            .resizable()
            .scaledToFit()
            .padding(8)
            .background(.white)
        } placeholder: {
          ProgressView()
        }
        Button(action: onDismiss) {
          ZStack {
            Image(systemName: "circle.fill")
              .scaleEffect(1.05)
              .foregroundColor(.black)
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.white)
          }
          .font(.title)
        }
        .padding(5)
      }

      Text(stageName)
        .font(.custom("Splatoon2", size: 12.0))
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .background(.black)
        .alignmentGuide(.bottom) { _ in 15 }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
  RegularScheduleDetailView()
    .environmentObject(ScheduleStore())
}
