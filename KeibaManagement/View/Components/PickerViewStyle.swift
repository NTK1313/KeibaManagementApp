//
//  PickerViewStyle.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/07/08.
//

import SwiftUI

struct PickerViewStyle : View {
    var value: Binding<String>
    var text: String
    var list: [String]
    var body: some View {
        Picker(selection: value, label: Text(text), content: {
            ForEach(list, id:\.self) { value in
                Text("\(value)")
                    .tag(value)
            }
        })
        .pickerStyle(.menu)
        .frame(alignment: .leading)
        .border(Color.cyan, width: 1)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.cyan, lineWidth: 2)
        )
    }
}

#Preview {
    struct Preview: View {
        @State var places:[String] = Consts.places
        @State var selectedPlace:String = Consts.places[0]
        var body: some View {
            PickerViewStyle(value: $selectedPlace, text: "places", list: places)
        }
    }
    return Preview()
}
