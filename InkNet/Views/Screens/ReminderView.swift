//
//  ReminderView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/15/24.
//

import SwiftUI

struct ReminderView: View {
  @EnvironmentObject var scheduleStore: ScheduleStore
  @Environment(\.presentationMode)
  var presentationMode
  @State private var anarchyEnabled = false
  @State private var selectedRegularStages = Set<String>()
  @State private var selectedAnarchyStages = Set<String>()
  @State private var regularStageEnabled = false
  @State private var anarchyStageEnabled = false
  @State private var anarchyModeEnabled = false

  var body: some View {
    NavigationView {
      Form {
        Section(header: headerView) {
          if regularStageEnabled {
            stageSelectionGrid(
              stages: scheduleStore.getStages(),
              selectedStages: $selectedRegularStages,
              highlightColor: "TurfWarGreen")
          }
          if anarchyEnabled {
            Toggle("Mode", isOn: $anarchyModeEnabled)
              .font(.custom("Splatoon2", size: 18.0))
            Toggle("Stage", isOn: $anarchyStageEnabled)
              .font(.custom("Splatoon2", size: 18.0))
            if anarchyStageEnabled {
              stageSelectionGrid(
                stages: scheduleStore.getStages(),
                selectedStages: $selectedAnarchyStages,
                highlightColor: "AnarchyOrange")
            }
          }
        }
      }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text("Add Reminder")
            .font(.custom("Splatoon2", size: 28.0))
            .foregroundColor(.primary)
        }
      }
      .navigationBarItems(trailing: Button("Save", action: savePreferencesAndDismiss))
      .onAppear(perform: loadPreferences)
    }
  }

  private var headerView: some View {
    VStack {
      HStack {
        Text("Turf War")
          .font(.custom("Splatoon2", size: 18.0))
        Toggle("Stage", isOn: $regularStageEnabled)
          .font(.custom("Splatoon2", size: 18.0))
      }
      HStack {
        Text("Anarchy Battle")
          .font(.custom("Splatoon2", size: 18.0))
        Toggle("", isOn: $anarchyEnabled)
          .font(.custom("Splatoon2", size: 18.0))
      }
    }
  }

  private func stageSelectionGrid(stages: [VsStagesNode]?, selectedStages: Binding<Set<String>>, highlightColor: String) -> some View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    return LazyVGrid(columns: columns, spacing: 0) {
      ForEach(stages ?? [], id: \.vsStageID) { stage in
        StageImageView(stage: stage, selectedStages: selectedStages, highlightColor: Color(highlightColor))
      }
    }
  }

  private func savePreferencesAndDismiss() {
    savePreferences()
    presentationMode.wrappedValue.dismiss()
  }

  private func savePreferences() {
    UserDefaults.standard.set(Array(selectedRegularStages), forKey: "selectedRegularStages")
    UserDefaults.standard.set(Array(selectedAnarchyStages), forKey: "selectedAnarchyStages")
  }

  private func loadPreferences() {
    selectedRegularStages = Set(UserDefaults.standard.array(forKey: "selectedRegularStages") as? [String] ?? [])
    selectedAnarchyStages = Set(UserDefaults.standard.array(forKey: "selectedAnarchyStages") as? [String] ?? [])
    regularStageEnabled = !selectedRegularStages.isEmpty
    anarchyStageEnabled = !selectedAnarchyStages.isEmpty
  }
}

struct StageImageView: View {
  let stage: VsStagesNode
  @Binding var selectedStages: Set<String>
  let highlightColor: Color

  var body: some View {
    ZStack(alignment: .bottom) {
      AsyncImage(url: URL(string: stage.originalImage.url)) { image in
        image
          .resizable()
          .scaledToFit()
          .clipShape(RoundedRectangle(cornerRadius: 12.0))
          .border(selectedStages.contains(stage.name) ? highlightColor : Color.clear, width: 5)
      } placeholder: {
        Image(systemName: "photo").resizable().scaledToFit()
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
      if selectedStages.contains(stage.name) {
        selectedStages.remove(stage.name)
      } else {
        selectedStages.insert(stage.name)
      }
    }
  }
}


#Preview {
  ReminderView()
    .environmentObject(ScheduleStore())
}
