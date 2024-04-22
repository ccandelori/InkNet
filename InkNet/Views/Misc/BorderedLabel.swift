//
//  BorderedLabel.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/20/24.
//

import SwiftUI

struct BorderedLabel: View {
  let text: String
  let textSize: CGFloat
  let width: CGFloat
  let color: String
  let rotation: Double

  init(
    text: String,
    textSize: CGFloat = 12.0,
    width: CGFloat = 40.0,
    color: String = "AccentPurple",
    rotation: Double = -15
  ) {
    self.text = text
    self.textSize = textSize
    self.width = width
    self.color = color
    self.rotation = rotation
  }

  var body: some View {
    ShadedSplatoon2Text(text: text, size: textSize)
      .padding(.horizontal)
      .background(Color(color))
      .foregroundColor(.white)
      .rotationEffect(.degrees(rotation))
      .overlay(
        Rectangle()
          .stroke(lineWidth: 1.2)
          .foregroundColor(.white)
          .rotationEffect(.degrees(rotation))
          .frame(width: width, height: textSize + 4.0)
      )
  }
}

#Preview {
  BorderedLabel(text: "The Daily Drop", width: 90)
}
