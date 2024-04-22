//
//  TextViews.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/22/24.
//

import SwiftUI

struct ShadedSplatoon1Text: View {
  let text: String
  let size: CGFloat
  let color: Color = .white

  var body: some View {
    ZStack {
      Text(text)
        .foregroundColor(.black)
        .offset(x: 2, y: 2)
      Text(text)
        .foregroundColor(color)
    }
    .font(.custom("Splatoon1", size: size))
  }
}

struct ShadedSplatoon2Text: View {
  let text: String
  let size: CGFloat
  let color: Color = .white

  var body: some View {
    ZStack {
      Text(text)
        .foregroundColor(.black)
        .offset(x: 2, y: 2)
      Text(text)
        .foregroundColor(color)
    }
    .font(.custom("Splatoon2", size: size))
  }
}
