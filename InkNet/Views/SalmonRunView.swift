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
            if let coop = scheduleStore.getCoopGroupingSchedules() {
                let current = coop.first!
                Text("\(scheduleStore.formatDateTime(from: current.startTime)) - \(scheduleStore.formatDateTime(from: current.startTime))")
                    .font(.custom("Splatoon1", size: 12.0))
                    .padding(.horizontal)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12.0)
                        .frame(height: 110)
                        .foregroundColor(.gray)
                    HStack {
                        ZStack(alignment: .bottom) {
                            AsyncImage(url: URL(string: current.setting.coopStage.image.url))  { image in
                                image.image?
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 12.0))
                            }

                            Text(current.setting.coopStage.name)
                                .font(.custom("Splatoon2", size: 11.0))
                                .foregroundColor(.white)
                                .padding(.horizontal, 4)
                                .background(.black)
                                .alignmentGuide(.bottom) { _ in 10 }
                        }

                        VStack(spacing: 0) {
                            ZStack {
                                Text(current.setting.boss.name)
                                    .font(.custom("Splatoon2", size: 16.0))
                                    .foregroundColor(.black)

                                Text(current.setting.boss.name)
                                    .font(.custom("Splatoon2", size: 16.0))
                                    .foregroundColor(.white)
                                    .offset(x: -1, y: -1)
                            }
                            ZStack {
                                RoundedRectangle(cornerRadius: 50.0)
                                    .opacity(0.2)
                                    .frame(height: 60)

                                HStack {
                                    ForEach(current.setting.weapons, id: \.name) { weapon in
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
                .padding(.horizontal)

                ForEach(coop[1...], id: \.startTime) { upcoming in
                    Text("\(scheduleStore.formatDateTime(from: upcoming.startTime)) - \(scheduleStore.formatDateTime(from: upcoming.startTime))")
                        .font(.custom("Splatoon1", size: 12.0))
                        .padding(.horizontal)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))

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
