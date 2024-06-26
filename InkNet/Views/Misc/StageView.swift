//
//  StageView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/5/24.
//

import SwiftUI

struct StageView: View {
  let stages: [Stage]
  var onTap: (URL, String) -> Void

  var body: some View {
    HStack {
      ForEach(stages, id: \.vsStageID) { stage in
        ZStack(alignment: .bottom) {
          AsyncImage(url: URL(string: stage.image.url)) { image in
            image
              .resizable()
              .scaledToFit()
              .clipShape(RoundedRectangle(cornerRadius: 12.0))
          } placeholder: {
            Image(systemName: "photo")
              .resizable()
              .scaledToFit()
          }
          Text(stage.name)
            .font(.custom("Splatoon2", size: 9.0))
            .foregroundColor(.white)
            .padding(.horizontal, 4)
            .background(.black)
            .alignmentGuide(.bottom) { _ in 10 }
        }
        .frame(height: 125)
        .onTapGesture {
          if let url = URL(string: stage.image.url) {
            onTap(url, stage.name)
          }
        }
      }
    }
  }
}

// #Preview {
//     StageView()
// }
