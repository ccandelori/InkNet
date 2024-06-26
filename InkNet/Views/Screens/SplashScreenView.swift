//
//  SplashScreenView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/11/24.
//

import SwiftUI

struct SplashScreenView: View {
  @Binding var isPresented: Bool

  @State private var scale = CGSize(width: 0.5, height: 0.5)
  @State private var imageOpacity = 1.0
  @State private var rotation = 0.0

  var body: some View {
    ZStack {
      Image("iPhone 15 Pro")
        .resizable()
        .ignoresSafeArea()
      ShadedSplatoon1Text(text: "InkNet", size: 60.0)
        .scaleEffect(scale)
        .rotationEffect(.degrees(rotation))
    }
    .onAppear {
      withAnimation(.bouncy(duration: 1.5)) {
        scale = CGSize(width: 1, height: 1)
        imageOpacity = 1.0
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
        withAnimation(.easeIn(duration: 0.35)) {
          scale = CGSize(width: 50, height: 50)
          rotation = 360
        }
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + 2.9) {
        withAnimation(.easeIn(duration: 0.2)) {
          isPresented.toggle()
        }
      }
    }
  }
}

#Preview {
  SplashScreenView(isPresented: .constant(true))
}
