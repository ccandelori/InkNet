//
//  HangTabView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/7/24.
//

import SwiftUI

struct HangTabView: View {
    let color: String

    var body: some View {
        ZStack(alignment: .top) {
            Image("monsters-transparent-bg")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(.degrees(90))
                .frame(width: .infinity, height: 600)
                .scaleEffect(1.7)
                .background(Color("AnarchyOrange"))
                .clipShape(RoundedRectangle(cornerRadius: 16.0))
                .padding(.horizontal, 5)


            RoundedRectangle(cornerRadius: 50.0)
                .frame(width: 70, height: 18)
                .offset(y: 25)
            Circle()
                .frame(width: 18)
                .offset(y: 16)
        }
    }
}

#Preview {
    HangTabView(color: "AnarchyOrange")
}
