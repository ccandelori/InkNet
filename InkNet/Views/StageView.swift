//
//  StageView.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/5/24.
//

import SwiftUI

struct StageView: View {
    let stages: [Stage]

    var body: some View {
        HStack {
            ForEach(stages, id: \.vsStageID) { stage in
                ZStack {
                    AsyncImage(url: URL(string: stage.image.url)) { image in
                        image.image?.resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
                    }
                    Text(stage.name)
                        .font(.custom("Splatoon2", size: 9.0))
                        .foregroundColor(.white)
                        .padding(.horizontal, 4)
                        .background(.black)
                        .offset(y: 40)
                }
            }
        }
    }
}

//#Preview {
//    StageView()
//}
