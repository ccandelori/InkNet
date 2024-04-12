//
//  SalmonRunView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/5/24.
//

import SwiftUI

struct SalmonRunView: View {
  @StateObject var scheduleStore = ScheduleStore()

  var body: some View {
    NavigationStack {
      ZStack {
        Image("information-bg")
          .resizable()
          .ignoresSafeArea(.all)

        HangTabView(color: "AnarchyOrange")
        VStack(alignment: .leading) {
          ShadedSplatoon1Text(text: "Salmon Run", size: 34.0)
            .padding(.leading)
            .offset(y: 20)

          if let coop = scheduleStore.getCoopGroupingSchedules() {
            let current = coop.first!
            let start = scheduleStore.formatDateTime(from: current.startTime)
            let end = scheduleStore.formatDateTime(from: current.endTime)
            ShadedSplatoon2Text(text: "\(start) - \(end)", size: 12.0)
              .padding(.leading)
            ZStack(alignment: .topLeading) {
              HStack {
                StageImage(
                  imageURL: current.setting.coopStage.image.url,
                  stageName: current.setting.coopStage.name)
                StageParameters(
                  bossName: current.setting.boss.name,
                  weapons: current.setting.weapons)
              }

              Text("Now")
                .font(.custom("Splatoon2", size: 12.0))
                .padding(.horizontal)
                .background(Color("AccentPurple"))
                .foregroundColor(.white)
                .rotationEffect(.degrees(-15.0))
                .overlay(Rectangle()
                  .stroke(lineWidth: 1.2)
                  .foregroundColor(.white)
                  .rotationEffect(.degrees(-15.0))
                  .frame(width: 40, height: 18))
            }
            .padding(.horizontal)

            ZStack(alignment: .topLeading) {
              RoundedRectangle(cornerRadius: 16.0)
                .padding(.horizontal)
                .frame(height: 350)
                .opacity(0.4)
              VStack(alignment: .leading) {
                ForEach(coop[1...], id: \.startTime) { upcoming in
                  HStack {
                    StageImage(
                      imageURL: upcoming.setting.coopStage.thumbnailImage!.url,
                      stageName: upcoming.setting.coopStage.name)
                    .frame(height: 65)

                    VStack {
                      ShadedSplatoon2Text(
                        text: "\(scheduleStore.formatDateTime(from: upcoming.startTime)) - \(scheduleStore.formatDateTime(from: upcoming.endTime))",
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
              .padding(.leading)

              Text("Coming Up")
                .font(.custom("Splatoon2", size: 12.0))
                .padding(.horizontal)
                .background(Color("AccentPurple"))
                .foregroundColor(.white)
                .rotationEffect(.degrees(-15.0))
                .overlay(Rectangle()
                  .stroke(lineWidth: 1.2)
                  .foregroundColor(.white)
                  .rotationEffect(.degrees(-15.0))
                  .frame(width: 70, height: 18)
                )
                .offset(x: 15, y: -10)
            }
          }
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

#Preview {
  SalmonRunView()
}

struct StageImage: View {
  let imageURL: String
  let stageName: String

  var body: some View {
    ZStack(alignment: .bottom) {
      AsyncImage(url: URL(string: imageURL)) { image in
        image
          .resizable()
          .scaledToFit()
          .clipShape(RoundedRectangle(cornerRadius: 12.0))
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
          .opacity(0.2)
          .frame(height: 60)

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

struct ShadedSplatoon1Text: View {
  let text: String
  let size: CGFloat

  var body: some View {
    ZStack {
      Text(text)
        .offset(x: 2, y: 2)
      Text(text)
        .foregroundColor(.white)
    }
    .font(.custom("Splatoon1", size: size))
  }
}

struct ShadedSplatoon2Text: View {
  let text: String
  let size: CGFloat

  var body: some View {
    ZStack {
      Text(text)
        .offset(x: 2, y: 2)
      Text(text)
        .foregroundColor(.white)
    }
    .font(.custom("Splatoon2", size: size))
  }
}
