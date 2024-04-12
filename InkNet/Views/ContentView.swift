//
//  ContentView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/5/24.
//

import SwiftUI

enum TabSelection {
  case schedule
  case salmonRun
  case challenge
  case gear
  case splatfest
}

struct ContentView: View {
  @State var currentTab: TabSelection = .schedule

  var body: some View {
    TabView(selection: $currentTab) {
      ScheduleView()
        .tabItem { Label("Schedule", systemImage: "") }
        .tag(TabSelection.schedule)
      SalmonRunView()
        .tabItem { Label("Salmon Run", systemImage: "") }
        .tag(TabSelection.salmonRun)
      ChallengeView()
        .tabItem { Label("Challenge", systemImage: "") }
        .tag(TabSelection.challenge)
      GearView()
        .tabItem { Label("Gear", systemImage: "") }
        .tag(TabSelection.gear)
      SplatFestView()
        .tabItem { Label("Splatfest", systemImage: "") }
        .tag(TabSelection.splatfest)
    }
  }
}

#Preview {
  ContentView()
}
