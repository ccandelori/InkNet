//
//  SalmonRunView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/5/24.
//

import SwiftUI

struct SalmonRunView: View {
  @EnvironmentObject var scheduleStore: ScheduleStore
  @State private var selectedImageUrl: URL?
  @State private var selectedStageName: String?

  var body: some View {
    NavigationStack {
      ZStack {
        backgroundImageView
        ZStack {
          HangTabView(color: "AnarchyOrange", overlay: "monsters-transparent-bg")
            .frame(height: 600)
          contentStack
            .overlay(fullImageViewOverlay)
        }
      }
      .shadow(radius: 5)
    }
    .onAppear {
      Task {
        await scheduleStore.fetchScheduleDataIfNeeded()
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

  private var contentStack: some View {
    VStack(alignment: .leading) {
      headerText
      if let coop = scheduleStore.getCoopGroupingSchedules() {
        currentRunView(current: coop.first!)
        upcomingRunsView(coop: Array(coop.dropFirst()))
      }
    }
  }

  private var headerText: some View {
    ShadedSplatoon1Text(text: "Salmon Run", size: 34.0)
      .padding(.leading)
      .offset(y: 20)
  }

  private func currentRunView(current: PurpleNode) -> some View {
    let timeRange = "\(scheduleStore.formatDateTime(from: current.startTime)) - \(scheduleStore.formatDateTime(from: current.endTime))"
    return VStack {
      ShadedSplatoon2Text(text: timeRange, size: 12.0)
        .padding(.leading)
      CurrentRunDetailsView(current: current) {
        self.selectedImageUrl = URL(string: current.setting.coopStage.image.url)
        self.selectedStageName = current.setting.coopStage.name
      }
    }
  }

  private func upcomingRunsView(coop: [PurpleNode]) -> some View {
    UpcomingRunsDetailsView(coop: coop, scheduleStore: scheduleStore) { stage in
      self.selectedImageUrl = URL(string: stage.setting.coopStage.image.url)
      self.selectedStageName = stage.setting.coopStage.name
    }
  }

  private var fullImageViewOverlay: some View {
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

struct CurrentRunDetailsView: View {
  let current: PurpleNode
  var onTap: () -> Void

  var body: some View {
    ZStack(alignment: .topLeading) {
      HStack {
        StageImage(
          imageURL: current.setting.coopStage.image.url,
          stageName: current.setting.coopStage.name,
          onTap: onTap
        )
        StageParameters(
          bossName: current.setting.boss.name,
          weapons: current.setting.weapons)
      }
      BorderedLabel(text: "Now")
    }
    .padding(.horizontal)
  }
}

struct UpcomingRunsDetailsView: View {
  let coop: [PurpleNode]
  var scheduleStore: ScheduleStore
  var onTap: (PurpleNode) -> Void

  var body: some View {
    ZStack(alignment: .topLeading) {
      RoundedRectangle(cornerRadius: 16.0)
        .padding(.horizontal)
        .frame(height: 350)
        .foregroundColor(.black)
        .opacity(0.4)
      VStack(alignment: .leading) {
        ForEach(coop, id: \.startTime) { upcoming in
          UpcomingRunRow(upcoming: upcoming, formatDate: scheduleStore.formatDateTime) { onTap(upcoming) }
        }
      }
      .padding(.leading)
      BorderedLabel(text: "Coming Up", width: 70)
        .offset(x: 15, y: -10)
    }
  }
}

struct UpcomingRunRow: View {
  let upcoming: PurpleNode
  var formatDate: (Date) -> String
  var onTap: () -> Void

  var body: some View {
    HStack {
      StageImage(
        imageURL: upcoming.setting.coopStage.thumbnailImage!.url,
        stageName: upcoming.setting.coopStage.name,
        onTap: onTap
      )
      .frame(height: 65)

      VStack {
        ShadedSplatoon2Text(
          text: "\(formatDate(upcoming.startTime)) - \(formatDate(upcoming.endTime))",
          size: 12.0)
        HStack(spacing: 18) {
          ForEach(upcoming.setting.weapons, id: \.name) { weapon in
            AsyncImage(url: URL(string: weapon.image.url)) { image in
              image
                .resizable()
                .scaledToFit()
            } placeholder: {
              Image(systemName: "photo")
                .resizable()
                .scaledToFit()
            }
          }
        }
      }
    }
    .padding([.horizontal, .top], 5)
    .frame(height: 80)
  }
}

struct StageImage: View {
  let imageURL: String
  let stageName: String
  var onTap: () -> Void

  var body: some View {
    ZStack(alignment: .bottom) {
      AsyncImage(url: URL(string: imageURL)) { image in
        image
          .resizable()
          .scaledToFit()
          .clipShape(RoundedRectangle(cornerRadius: 12.0))
          .onTapGesture {
            onTap()
          }
      } placeholder: {
        Image(systemName: "photo")
      }

      Text(stageName)
        .font(.custom("Splatoon2", size: 11.0))
        .foregroundColor(.white)
        .padding(.horizontal, 4)
        .background(.black)
        .alignmentGuide(.bottom) { _ in 10 }
    }
  }
}

struct StageParameters: View {
  let bossName: String
  let weapons: [Weapon]
  var body: some View {
    VStack(spacing: 0) {
      ZStack {
        Text(bossName)
          .foregroundColor(.black)
        Text(bossName)
          .foregroundColor(.white)
          .offset(x: -1, y: -1)
      }
      .font(.custom("Splatoon2", size: 16.0))

      ZStack {
        RoundedRectangle(cornerRadius: 50.0)
          .opacity(0.4)
          .frame(height: 60)
          .foregroundColor(.black)

        HStack {
          ForEach(weapons, id: \.name) { weapon in
            AsyncImage(url: URL(string: weapon.image.url)) { image in
              image.image?
                .resizable()
                .scaledToFit()
            }
          }
        }
      }
    }
  }
}

#Preview {
  SalmonRunView()
    .environmentObject(ScheduleStore())
}
