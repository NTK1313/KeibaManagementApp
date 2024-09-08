//
//  CommonToast.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/07/13.
//

import SwiftUI

struct CommonToast: View {
    var title: String
    @Binding var isShown: Bool
    var body: some View {
        VStack{
            Spacer()
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(30)
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(Capsule())
        }
        .frame(width: UIScreen.main.bounds.width / 1.25)
        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
        .onTapGesture {
            withAnimation {
                self.isShown = false
            }
        }
        .onAppear{
            withAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ){
                    self.isShown = false
                }
            }
        }
    }
}

#Preview {
    let title = "登録完了"
    @State var isShown1 = true
    return CommonToast(title:title, isShown: $isShown1)
}
