//
//  ChallengeView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/5/24.
//

import SwiftUI

// MARK: - ChallengeView

struct ChallengeView: View {
  @StateObject var viewModel = ChallengeViewModel(scheduleStore: ScheduleStore.shared)


  var body: some View {
    NavigationStack {
      ZStack {
        BackgroundImageView()
        if viewModel.isLoading {
          ProgressView()
        } else {
          ChallengeContentView(challenges: viewModel.challenges)
        }
      }
      .onAppear {
        Task {
          await viewModel.fetchChallenges()
        }
      }
    }
  }
}

// MARK: - BackgroundImageView

struct BackgroundImageView: View {
  var body: some View {
    Image("bg-light")
      .resizable()
      .ignoresSafeArea(.all)
      .opacity(0.2)
      .scaleEffect(CGSize(width: 2.33, height: 1.33))
  }
}

// MARK: - ChallengeContentView

struct ChallengeContentView: View {
  var challenges: [ChallengeType: [EventSchedulesNode]]

  var body: some View {
    ScrollView {
      ForEach(ChallengeType.allCases, id: \.self) { type in
        if let challengesForType = challenges[type] {
          ChallengeStack(challenges: challengesForType)
        }
      }
    }
  }
}

// MARK: - ChallengeStack

struct ChallengeStack: View {
  var challenges: [EventSchedulesNode]

  var body: some View {
    ZStack {
      HangTabView(color: "ChallengeMagenta", overlay: "tapes-transparent")
      VStack(alignment: .leading, spacing: 0) {
        ForEach(challenges, id: \.id) { challenge in
          ChallengeDetail(challenge: challenge)
        }
      }
    }
  }
}

// MARK: - ChallengeDetail
struct ChallengeDetail: View {
  @State private var selectedImageUrl: URL?
  @State private var selectedStageName: String?
  var challenge: EventSchedulesNode
  private let dateFormatter = DateFormatter()

  init(challenge: EventSchedulesNode) {
    self.challenge = challenge
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
  }

  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        Spacer(minLength: 45)
        ChallengeRotationTitle(
          image: challenge.leagueMatchSetting.vsRule.rule.rawValue.lowercased(),
          title: challenge.leagueMatchSetting.leagueMatchEvent?.name ?? "Unknown Challenge",
          subtitle: challenge.leagueMatchSetting.leagueMatchEvent?.desc ?? "No Description"
        )
        .padding(.horizontal)

        StageView(stages: challenge.leagueMatchSetting.vsStages) { url, name in
          self.selectedImageUrl = url
          self.selectedStageName = name
        }
        .padding(.horizontal)
        .padding(.vertical, -30)

        timePeriodsView
      }
      overlayView
    }
  }

  private var timePeriodsView: some View {
    ZStack(alignment: .leading) {
      Color.black
        .opacity(0.4)
        .clipShape(RoundedRectangle(cornerRadius: 16.0))
      VStack(alignment: .leading, spacing: 5) {
        ForEach(challenge.timePeriods, id: \.startTime) { period in
          ChallengeRotationRow(
            image: challenge.leagueMatchSetting.vsRule.rule.rawValue.lowercased(),
            timeRange: "\(dateFormatter.string(from: period.startTime)) - \(dateFormatter.string(from: period.endTime))")
        }
      }
      .padding()
    }
    .padding()
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


struct ChallengeRotationTitle: View {
  let image: String
  let title: String
  let subtitle: String

  var body: some View {
    HStack {
      Image(image)
      VStack(alignment: .leading, spacing: -15) {
        ShadedSplatoon1Text(text: title, size: 28.0)
        ShadedSplatoon2Text(text: subtitle, size: 18.0)
      }
    }
  }
}

struct ChallengeRotationRow: View {
  let image: String
  let timeRange: String

  var body: some View {
    HStack {
      Image(image)
        .resizable()
        .scaledToFit()
        .frame(height: 24.0)
      ShadedSplatoon2Text(text: timeRange, size: 12.0)
    }
  }
}


@MainActor
class ChallengeViewModel: ObservableObject {
  @Published var challenges: [ChallengeType: [EventSchedulesNode]] = [:]
  @Published var isLoading = false

  private var scheduleStore: ScheduleStore

  init(scheduleStore: ScheduleStore) {
    self.scheduleStore = scheduleStore
  }

  func fetchChallenges() async {
    isLoading = true
    await scheduleStore.fetchScheduleDataIfNeeded()
    if let events = scheduleStore.getEventSchedules() {
      organizeChallenges(events)
    }
    isLoading = false
  }

  private func organizeChallenges(_ events: [EventSchedulesNode]) {
    challenges = Dictionary(grouping: events) { $0.challengeType }
  }
}


#Preview {
  ChallengeView()
    .environmentObject(ScheduleStore())
}
