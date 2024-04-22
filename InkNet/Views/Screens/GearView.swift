//
//  GearView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/5/24.
//

import SwiftUI

struct GearView: View {
  @StateObject var gearStore = GearStore()

  var body: some View {
    NavigationView {
      ZStack {
        backgroundView
        content
      }
      .onAppear {
        loadGears()
      }
      .background(
        Image("bg-light")
          .ignoresSafeArea(.all)
          .opacity(0.2)
          .scaleEffect(0.65)
      )
    }
  }

  func formatSaleEndTime(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return "Until \(dateFormatter.string(from: date))"
  }

  func remainingTimeDescription(until endDate: Date) -> String {
    let now = Date()
    let remainingSeconds = Calendar.current.dateComponents([.second], from: now, to: endDate).second ?? 0
    let hours = remainingSeconds / 3600
    let minutes = (remainingSeconds % 3600) / 60

    if hours > 0 {
      return "\(hours) hours, \(minutes) minutes left"
    } else if minutes > 0 {
      return "\(minutes) minutes left"
    } else {
      return "Less than a minute left"
    }
  }


  private var backgroundView: some View {
    HangTabView(color: "Burple", overlay: "circles-transparent")
      .frame(height: 650)
  }

  private var content: some View {
    VStack(alignment: .leading) {
      ZStack(alignment: .bottom) {
        brandImage
        BorderedLabel(
          text:"The Daily Drop",
          width: 90,
          color: "XRankTeal",
          rotation: 0
        )
          .offset(y: 10)
      }
      VStack(alignment: .trailing) {
        if let gearData = gearStore.gearData?.data.gesotown.pickupBrand {
          ShadedSplatoon2Text(text: formatSaleEndTime(gearData.saleEndTime), size: 14.0)
        } else {
          Text("Loading or no data available")
        }
      }
      gearList
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private var brandImage: some View {
    if let urlString = gearStore.gearData?.data.gesotown.pickupBrand.image.url,
       let url = URL(string: urlString) {
      return AnyView(
        AsyncImage(url: url) { image in
          image.resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity)
        } placeholder: {
          ProgressView()
        }
      )
    } else {
      return AnyView(
        Image(systemName: "photo")
          .resizable()
          .scaledToFit()
          .frame(width: 50, height: 50)
          .foregroundColor(.gray)
      )
    }
  }

  private var gearList: some View {
    VStack(alignment: .leading, spacing: 5) {
      if let brandGears = gearStore.gearData?.data.gesotown.pickupBrand.brandGears {
        ForEach(brandGears, id: \.id) { gear in
          gearRow(for: gear)
        }
      }
    }
  }

  private func gearRow(for gear: DGear) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 16.0)
        .foregroundColor(.white)
        .opacity(0.3)
        .frame(height: 100)
      HStack(alignment: .center, spacing: 15) {
        AsyncImage(url: URL(string: gear.gear.image.url)) { image in
          image
            .resizable()
            .scaledToFit()
            .frame(width: 70)
        } placeholder: {
          Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: 60)
            .foregroundColor(.gray)
        }
        VStack(alignment: .leading, spacing: 2) {
          ShadedSplatoon2Text(text: remainingTimeDescription(until: gear.saleEndTime), size: 10.0)
          HStack {
            AsyncImage(url: URL(string: gear.gear.brand.image!.url)) { image in
              image
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 4.0))
            } placeholder: {
              Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
            }
            ShadedSplatoon2Text(text: gear.gear.name, size: 12.0)
          }
          HStack(spacing: 2) {
            AsyncImage(url: URL(string: gear.gear.primaryGearPower.image.url)) { image in
              image
                .resizable()
                .scaledToFit()
                .frame(width: 24)
                .background(Color.black)
                .clipShape(Circle())
            } placeholder: {
              Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
            }
            ForEach(gear.gear.additionalGearPowers, id: \.splatoon3InkID) { power in
              AsyncImage(url: URL(string: power.image.url)) { image in
                image
                  .resizable()
                  .scaledToFit()
                  .frame(width: 24)
                  .background(Color.black)
                  .clipShape(Circle())
              }  placeholder: {}
            }
            Spacer()
            HStack {
              Image("gesotown-coin")
              ShadedSplatoon1Text(text: "\(gear.price)", size: 12.0)
            }
            .padding(.horizontal)
            .background(Color.black)
          }
        }
      }
      .padding(.horizontal)
    }
  }

  private func loadGears() {
    Task {
      await gearStore.fetchGearDataIfNeeded()
    }
  }
}


#Preview {
  GearView()
}
