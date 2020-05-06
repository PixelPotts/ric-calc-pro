//
//  Helpers.swift
//  ric-calculator
//
//  Created by Bryan Potts on 5/6/20.
//  Copyright © 2020 Bryan Potts. All rights reserved.
//

import SwiftUI

struct ListItem: View {
    var id: String
    var title: String
    var cost: Int
    var body: some View {
        HStack {
            Text(self.title)
            Spacer()
            Text("❯")
                .padding(.leading,10)
                .padding(.trailing,10)
        }
        .padding(15)
        .padding(.bottom,0)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct Field: View {
    var title: String
    var placeholder: String
    var text: Binding<String>
    
    var body: some View {
        VStack {
            Text(title)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            TextField(self.placeholder, text: self.text)
        }
    }
}

struct NeumorphicButtonStyle: ButtonStyle {
    var bgColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .shadow(color: .white, radius: configuration.isPressed ? 7: 10, x: configuration.isPressed ? -5: -15, y: configuration.isPressed ? -5: -15)
                        .shadow(color: .black, radius: configuration.isPressed ? 7: 10, x: configuration.isPressed ? 5: 15, y: configuration.isPressed ? 5: 15)
                        .blendMode(.overlay)
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(bgColor)
                }
                .frame(minWidth: 300)
        )
            .scaleEffect(configuration.isPressed ? 0.95: 1)
            .foregroundColor(Color.white)
            .animation(.spring())
    }
}

struct Helpers_Previews: PreviewProvider {
    static var previews: some View {
        Button("Neumorphic", action: {

        }).buttonStyle(NeumorphicButtonStyle(bgColor: Color.blue))
    }
}
