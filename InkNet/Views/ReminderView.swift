//
//  ReminderView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/15/24.
//

import SwiftUI

struct ReminderView: View {
  @EnvironmentObject var scheduleStore: ScheduleStore
  @State private var anarchyModeEnabled = false
  @State private var selectedRegularStages = Set<String>()
  @State private var selectedAnarchyStages = Set<String>()
  @State private var regularStageEnabled = false
  @State private var anarchyStageEnabled = false

  var body: some View {
    NavigationView {
      Form {
        Section {
          HStack {
            Spacer()
            Text("Add Reminder")
              .font(.custom("Splatoon2", size: 28.0))
            //            Spacer()
            Button("Save") {
              saveSelectedRegularStages()
              saveSelectedAnarchyStages()
            }
            .padding()
          }
          VStack {
            VStack {
              Text("Turf War")
                .font(.custom("Splatoon2", size: 18.0))
              Toggle(isOn: $regularStageEnabled) {
                Text("Stage")
                  .font(.custom("Splatoon2", size: 18.0))
              }
              if regularStageEnabled {
                let columns = [GridItem(.flexible()), GridItem(.flexible())]
                LazyVGrid(columns: columns, spacing: 0) {
                  if let stages = scheduleStore.getStages() {
                    ForEach(stages, id: \.vsStageID) { stage in
                      ZStack(alignment: .bottom) {
                        AsyncImage(url: URL(string: stage.originalImage.url)) { image in
                          image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
                            .border(selectedRegularStages.contains(stage.name) ? Color("TurfWarGreen") : Color.clear, width: 5)
                        } placeholder: {
                          Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                        }
                        Text(stage.name)
                          .font(.custom("Splatoon2", size: 9.0))
                          .foregroundColor(.white)
                          .padding(.horizontal, 4)
                          .background(.black)
                          .alignmentGuide(.bottom) { _ in 10 }
                      }
                      .frame(height: 125)
                      .onTapGesture {
                        toggleRegularStageSelection(stage: stage.name)
                      }
                    }
                  }
                }
              }
            }
            VStack {
              Text("Anarchy Battle")
                .font(.custom("Splatoon2", size: 18.0))
              Toggle(isOn: $anarchyModeEnabled) {
                Text("Game Mode")
                  .font(.custom("Splatoon2", size: 18.0))
              }
              Toggle(isOn: $anarchyStageEnabled) {
                Text("Stage")
                  .font(.custom("Splatoon2", size: 18.0))
              }
              if anarchyStageEnabled {
                let columns = [GridItem(.flexible()), GridItem(.flexible())]
                LazyVGrid(columns: columns, spacing: 0) {
                  if let stages = scheduleStore.getStages() {
                    ForEach(stages, id: \.vsStageID) { stage in
                      ZStack(alignment: .bottom) {
                        // TODO: Store the stage images on the device and use a normal Image object
                        AsyncImage(url: URL(string: stage.originalImage.url)) { image in
                          image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
                            .border(selectedAnarchyStages.contains(stage.name) ? Color("AnarchyOrange") : Color.clear, width: 5)
                        } placeholder: {
                          Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                        }
                        Text(stage.name)
                          .font(.custom("Splatoon2", size: 9.0))
                          .foregroundColor(.white)
                          .padding(.horizontal, 4)
                          .background(.black)
                          .alignmentGuide(.bottom) { _ in 10 }
                      }
                      .frame(height: 125)
                      .onTapGesture {
                        toggleAnarchyStageSelection(stage: stage.name)
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    .onAppear {
      loadSelectedRegularStages()
      loadSelectedAnarchyStages()
      regularStageEnabled = UserDefaults.standard.array(forKey: "selectedRegularStages") as? [String] != nil
      anarchyStageEnabled = UserDefaults.standard.array(forKey: "selectedAnarchyStages") as? [String] != nil
    }
  }

  func toggleRegularStageSelection(stage: String) {
    if selectedRegularStages.contains(stage) {
      selectedRegularStages.remove(stage)
    } else {
      selectedRegularStages.insert(stage)
    }
  }

  func toggleAnarchyStageSelection(stage: String) {
    if selectedAnarchyStages.contains(stage) {
      selectedAnarchyStages.remove(stage)
    } else {
      selectedAnarchyStages.insert(stage)
    }
  }

  func updatePreferences(for mode: String, isEnabled: Bool) {
    let key = (mode == "regular") ? "selectedRegularStages" : "selectedAnarchyStages"
  }

  func saveSelectedRegularStages() {
    UserDefaults.standard.set(Array(selectedRegularStages), forKey: "selectedRegularStages")
  }
  
  func saveSelectedAnarchyStages() {
    UserDefaults.standard.set(Array(selectedAnarchyStages), forKey: "selectedAnarchyStages")
  }

  func loadSelectedRegularStages() {
    if let stages = UserDefaults.standard.array(forKey: "selectedRegularStages") as? [String] {
      selectedRegularStages = Set(stages)
    }
  }

  func loadSelectedAnarchyStages() {
    if let stages = UserDefaults.standard.array(forKey: "selectedAnarchyStages") as? [String] {
      selectedAnarchyStages = Set(stages)
    }
  }
}

#Preview {
  ReminderView()
    .environmentObject(ScheduleStore())
}
