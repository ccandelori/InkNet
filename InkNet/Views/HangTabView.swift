//
//  HangTabView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/7/24.
//

import SwiftUI

struct HangTabView: View {
  let color: String
  let overlay: String

  var body: some View {
    ZStack(alignment: .top) {
      Image(overlay)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .rotationEffect(.degrees(90))
        .frame(width: .infinity, height: 600)
        .scaleEffect(1.7)
        .background(Color(color))
        .clipShape(RoundedRectangle(cornerRadius: Dimensions.cornerRadius.rawValue))
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
  HangTabView(color: "AnarchyOrange", overlay: "monsters-transparent-bg")
}
