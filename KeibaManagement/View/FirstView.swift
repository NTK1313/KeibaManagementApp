//
//  FirstView.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/06/26.
//

import SwiftUI

struct FirstView: View {
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button(action: {
                print("Button Pressed")
            }, label: {
                Text("ログイン")
            })
        }
    }
}

#Preview {
    FirstView()
}
