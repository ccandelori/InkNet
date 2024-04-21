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

struct MainAppView: View {
  @State var currentTab: TabSelection = .schedule

  var body: some View {
    TabView(selection: $currentTab) {
      ScheduleView()
        .tabItem { Label("Schedule", image: "regular") }
        .tag(TabSelection.schedule)
      SalmonRunView()
        .tabItem { Label("Salmon Run", image: "coop") }
        .tag(TabSelection.salmonRun)
      ChallengeView()
        .tabItem { Label("Challenge", image: "event") }
        .tag(TabSelection.challenge)
      GearView()
        .tabItem { Label("Gear", image: "carbon_roller_40px") }
        .tag(TabSelection.gear)
      SplatFestView()
        .tabItem { Label("Splatfest", systemImage: "") }
        .tag(TabSelection.splatfest)
    }
  }
}

#Preview {
  MainAppView()
    .environmentObject(ScheduleStore())
}
