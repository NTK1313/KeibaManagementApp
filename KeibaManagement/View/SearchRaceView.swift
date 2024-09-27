//
//  SearchRaceView.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/09/27.
//

import SwiftUI

struct SearchRaceView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white // 背景色
                
                Text("Tap the right half of the screen")
                    .font(.title)
                    .foregroundColor(.black)
            }
            .onTapGesture { location in
                let screenWidth = geometry.size.width
                
                // 画面の右半分をタップした場合の処理
                if location.x > screenWidth / 2 {
                    print("Tapped on the right half of the screen")
                } else {
                    print("Tapped on the left half of the screen")
                }
            }
        }
        .edgesIgnoringSafeArea(.all) // 画面全体をタップできるようにする
    }
}

#Preview {
    SearchRaceView()
}
