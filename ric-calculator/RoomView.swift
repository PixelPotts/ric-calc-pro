//
//  RoomView.swift
//  ric-calculator
//
//  Created by Bryan Potts on 5/6/20.
//  Copyright © 2020 Bryan Potts. All rights reserved.
//
import SwiftUI

/// TODO:
/// Singleton shared DAO object
/// Try passing in entire collection
/// Check out nested codables

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
    @State private var project: Dictionary<String,Any> = ["":[:]]
    @State private var docID: String = ""
    @State private var name: String = ""
    @State private var hasInstall = true
    @State private var hasTearout = true
    @State private var hasMaterial = true
    @State private var sqFtToInstall: String = ""
    @State private var yearHomeBuilt: String = ""
    @State private var materialCost: String = ""
    @State private var installMaterial: String = ""
    @State private var tearoutMaterial: String = ""
    @State private var sqFtOfTearout: String = ""
    
    init(room: Dictionary<String, Any>, project: Dictionary<String,Any>){
        self.project = project
        self.docID = room["docID"] as? String ?? ""
        self.name = room["name"] as? String ?? ""
        self.hasInstall = room["hasInstall"] as? Bool ?? true
        self.hasTearout = room["hasTearout"] as? Bool ?? true
        self.hasMaterial = room["hasMaterial"] as? Bool ?? true
        self.sqFtToInstall = room["sqFtToInstall"] as? String ?? ""
        self.yearHomeBuilt = room["yearHomeBuilt"] as? String ?? ""
        self.materialCost = room["materialCost"] as? String ?? ""
        self.installMaterial = room["installMaterial"] as? String ?? ""
        self.tearoutMaterial = room["tearoutMaterial"] as? String ?? ""
        self.sqFtOfTearout = room["sqFtOfTearout"] as? String ?? ""
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
                text: $name
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
                    text: $sqFtToInstall
                )
                Field(
                    title: "Year Home Built",
                    placeholder: "YYYY",
                    text: $yearHomeBuilt
                )
            }
            
            HStack {
                Field(
                    title: "Install Material",
                    placeholder: "0",
                    text: $installMaterial
                )
                Field(
                    title: "Material Cost",
                    placeholder: "0",
                    text: $materialCost
                )
            }
            
            HStack {
                Field(
                    title: "Tearout Material",
                    placeholder: "0",
                    text: $tearoutMaterial
                )
                Field(
                    title: "Sq. Ft. of Tearout",
                    placeholder: "YYYY",
                    text: $sqFtOfTearout
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
