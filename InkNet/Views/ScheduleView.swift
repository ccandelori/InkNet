//
//  ScheduleView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/12/24.
//

import SwiftUI

struct ScheduleView: View {
  var body: some View {
    NavigationStack {
      VStack(spacing: -20) {
        HStack {
          NavigationLink(destination: ScheduleDetailView()) {
            HStack {
              Image("regular")
              ShadedSplatoon1Text(text: "Regular", size: 21.0)
            }
            .frame(maxWidth: 200, maxHeight: 200)
            .background(
              ZStack {
                Color("TurfWarGreen")
                Image("tapes-transparent")
                  .resizable()
                  .scaledToFill()
              }
            )
            .clipShape(RoundedRectangle(cornerRadius: Dimensions.cornerRadius.rawValue))
          }
          NavigationLink(destination: ScheduleDetailView()) {
            HStack {
              Image("bankara")
              ShadedSplatoon1Text(text: "Anarchy", size: 21.0)
            }
            .frame(maxWidth: 200, maxHeight: 200)
            .background(
              ZStack {
                Color("AnarchyOrange")
                Image("tapes-transparent")
                  .resizable()
                  .scaledToFill()
              }
            )
          .clipShape(RoundedRectangle(cornerRadius: Dimensions.cornerRadius.rawValue))
          }
        }
        .padding()
        NavigationLink(destination: ScheduleDetailView()) {
          HStack {
            HStack {
              Image("event")
              ShadedSplatoon1Text(text: "Challenge", size: 21.0)
                .offset(x: -5)
            }
            .frame(maxWidth: 200, maxHeight: 200)
            .offset(x: -5)
            .background(
              ZStack {
                Color("ChallengeMagenta")
                Image("tapes-transparent")
                  .resizable()
                  .scaledToFill()
              }
            )
            .clipShape(RoundedRectangle(cornerRadius: Dimensions.cornerRadius.rawValue))
            NavigationLink(destination: ScheduleDetailView()) {
              HStack {
                Image("x")
                ShadedSplatoon1Text(text: "X Rank", size: 21.0)
              }
              .frame(maxWidth: 200, maxHeight: 200)
              .background(
                ZStack {
                  Color("XRankTeal")
                  Image("tapes-transparent")
                    .resizable()
                    .scaledToFill()
                }
              )
            .clipShape(RoundedRectangle(cornerRadius: Dimensions.cornerRadius.rawValue))
            }
          }
          .padding()
        }
      }
    }
  }
}

#Preview {
  ScheduleView()
}
