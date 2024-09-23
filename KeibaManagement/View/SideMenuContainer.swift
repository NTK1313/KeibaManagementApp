//
//  SideMenuContainer.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/09/22.
//

import SwiftUI

struct SideMenuContainer<Content:View>: View {
    @State var isSideMenuViewDisplay = false
    let content: Content
    
    var body: some View {
        ZStack{
            content
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            isSideMenuViewDisplay.toggle()
                        }) {
                            Image(systemName: "line.horizontal.3")  // ハンバーガーメニュー
                        }
                    }
                }
            SideMenuView(isSideMenuViewDisplay: $isSideMenuViewDisplay)
        }
    }
}

#Preview {
    SideMenuContainer(content: Text("Hello, World!"))
}
