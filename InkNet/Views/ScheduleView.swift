//
//  ScheduleView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/12/24.
//

import SwiftUI

struct ScheduleView: View {
  @EnvironmentObject var scheduleStore: ScheduleStore

  var body: some View {
    NavigationStack {
      VStack(spacing: -20) {
        HStack {
          NavigationLink(destination: RegularScheduleDetailView()) {
            ModeCardView(mode: "Regular", imageName: "regular", color: "TurfWarGreen")
          }
          NavigationLink(destination: RegularScheduleDetailView()) {
            ModeCardView(mode: "Anarchy", imageName: "bankara", color: "AnarchyOrange")
          }
        }
        .padding()
        HStack {
          NavigationLink(destination: RegularScheduleDetailView()) {
            ModeCardView(mode: "Challenge", imageName: "event", color: "ChallengeMagenta")
          }
          NavigationLink(destination: RegularScheduleDetailView()) {
            ModeCardView(mode: "X Rank", imageName: "x", color: "XRankTeal")
          }
        }
        .padding()
      }
      .background(
        Image("bg-light")
          .ignoresSafeArea(.all)
          .opacity(0.2)
          .scaleEffect(0.65)
      )
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
    .environmentObject(ScheduleStore())
}

struct ModeCardView: View {
  let mode: String
  let imageName: String
  let color: String

  var body: some View {
    VStack(spacing: 0) {
      Image(imageName)
      ShadedSplatoon1Text(text: mode, size: 21.0)
    }
    .frame(maxWidth: 200, maxHeight: 200)
    .background(
      ZStack {
        Color(color)
          .overlay(
            LinearGradient(
              colors: [.white.opacity(0.1), .black.opacity(0.2)],
              startPoint: .top,
              endPoint: .bottom))
        Image("tapes-transparent")
          .resizable()
          .scaledToFill()
          .rotationEffect(.degrees(Double.random(in: 0...360)))
      }
    )
    .clipShape(RoundedRectangle(cornerRadius: Dimensions.cornerRadius.rawValue))
  }
}
