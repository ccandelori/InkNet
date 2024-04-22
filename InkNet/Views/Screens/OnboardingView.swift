//
//  OnboardingView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/22/24.
//

import SwiftUI

struct OnboardingView: View {
  @Binding var hasOnboarded: Bool

  var body: some View {
    TabView {
      ForEach(0..<3) { index in
        OnboardingPage(index: index, hasOnboarded: $hasOnboarded)
      }
    }
    .tabViewStyle(PageTabViewStyle())
    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    .padding()
    .background(Color("Background"))
    .onAppear {
      setupOnboarding()
    }
  }

  private func setupOnboarding() {
    // Any additional setup if needed
  }
}

struct OnboardingPage: View {
  var index: Int
  @Binding var hasOnboarded: Bool

  var body: some View {
    VStack {
      Image("little-buddy")
        .resizable()
        .scaledToFit()
        .frame(height: 200)
      Text("Welcome to InkNet!")
        .font(.custom("Splatoon1", size: 24.0))
      Text("Placeholder view \(index)")
        .font(.custom("Splatoon2", size: 20.0))
      Button {
        hasOnboarded = true
      } label: {
        ZStack {
            Text("Got it!")
            .font(.custom("Splatoon2", size: 24.0))
            .foregroundColor(.white)
            .padding(.horizontal)
            .background(
              Color("ChallengeMagenta")
                .clipShape(RoundedRectangle(cornerRadius: 16.0))
            )
        }
      }
    }
  }
}

#Preview {
  OnboardingView(hasOnboarded: .constant(true))
}
