//
//  RoomView.swift
//  ric-calculator
//
//  Created by Bryan Potts on 5/6/20.
//  Copyright © 2020 Bryan Potts. All rights reserved.
//

import SwiftUI


// Singleton shared DAO object

// Try passing in entire collection
// Check out nested codables

public struct Room: Codable {
//    init(){}
    var id: String = ""
    var title: String = ""
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
    }
}

struct RoomView: View {
    @State private var title: String = ""
    @State private var installSqFt: String = "" // Q: how to handle this type properly across app
    @State private var yearHomeBuilt: Int = 0
    @State private var hasInstall = true
    @State private var hasMaterial = true
    @State private var hasTearout = true
    
    init(_ name: String){
        self.title = name
    }
    
    var body: some View {
        VStack {
            
            HStack {
                
                Spacer()
                NavigationLink(destination:EmptyView()) {
                    Text("Help >")
                }
            }
            .padding(.bottom,-22)
            
            // ROOM NAME
            Field(
                title: "Room Name",
                placeholder: "Kitchen",
                text: $title
            )
            
            // Toggles
            HStack {
                Toggle(isOn: self.$hasInstall) { Text("Install") }.frame(width:102).scaleEffect(0.8)
                Toggle(isOn: self.$hasTearout) { Text("Tearout") }.frame(width:115).scaleEffect(0.8)
                Toggle(isOn: self.$hasMaterial) { Text("Material") }.frame(width:119).scaleEffect(0.8)
            }
            .padding(.top,10)
            .padding(.bottom,20)
            
            // Sq. Ft, Home Built
            HStack {
                Field(
                    title: "Sq. Ft. to Install",
                    placeholder: "0",
                    text: $title
                )
                Field(
                    title: "Year Home Built",
                    placeholder: "YYYY",
                    text: $title
                )
            }
            
            HStack {
                Field(
                    title: "Install Material",
                    placeholder: "0",
                    text: $title
                )
                Field(
                    title: "Material Cost",
                    placeholder: "0",
                    text: $title
                )
            }
            
            HStack {
                Field(
                    title: "Tearout Material",
                    placeholder: "0",
                    text: $title
                )
                Field(
                    title: "Sq. Ft. of Tearout",
                    placeholder: "YYYY",
                    text: $title
                )
            }
            
            HStack {
                Text("Total")
                Spacer()
                Text("$5,830")
            }
            
            Button("Save Room", action: {

            })
                .buttonStyle(NeumorphicButtonStyle(bgColor: Color.blue))
                .frame(minWidth:0, maxWidth: .infinity)
                .padding(.top,40)
            
            Spacer()
        }
        .padding(20)
        .navigationBarTitle(Text("test"), displayMode: .inline)
    }
}
