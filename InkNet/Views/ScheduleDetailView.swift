//
//  ScheduleView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/5/24.
//

import SwiftUI

struct ScheduleDetailView: View {
  @StateObject var scheduleStore = ScheduleStore()
  @State private var selectedImageUrl: URL?
  @State private var selectedStageName: String?

  var body: some View {
    NavigationStack {
      ZStack {
        Color.black.opacity(0.7)
          .ignoresSafeArea(.all)
        ScrollView {
          VStack(alignment: .leading, spacing: -4) {
            if let turfWar = scheduleStore.getRegularSchedules() {
              ForEach(turfWar, id: \.startTime) { schedule in
                Text(scheduleStore.formatTime(from: schedule.startTime))
                  .font(.custom("Splatoon1", size: 12.0))
                  .padding(.horizontal)
                  .background(Color("TurfWarGreen"))
                  .clipShape(RoundedRectangle(cornerRadius: 25.0))

                StageView(stages: schedule.regularMatchSetting!.vsStages) { url, name in
                  self.selectedImageUrl = url
                  self.selectedStageName = name
                }
              }
            }
          }
          .padding(.horizontal)
        }
        .overlay(
          Group {
            if let url = selectedImageUrl, let name = selectedStageName {
              FullImageView(url: url, stageName: name) {
                self.selectedImageUrl = nil
                self.selectedStageName = nil
              }
            }
          }
        )
        .toolbar {
          ToolbarItem(placement: .principal) {
            HStack {
              Image("regular")
              ShadedSplatoon1Text(text: "Turf War", size: 24.0)
            }
          }
        }
      .listStyle(.plain)
      }
    }
    .onAppear {
      Task {
        await scheduleStore.fetchScheduleDataIfNeeded()
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
  ScheduleDetailView()
}
