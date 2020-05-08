//
//  Project.swift
//  ric-calculator
//
//  Created by Bryan Potts on 5/6/20.
//  Copyright © 2020 Bryan Potts. All rights reserved.
//

import SwiftUI

var rooms: [Dictionary<String,Any>] = [
    [
        "id": "B00001",
        "title": "Living Room",
        "cost": 530
    ],
    [
        "id": "B00002",
        "title": "Dining Room",
        "cost": 1200
    ]
]

struct ProjectView: View {
    var rooms: Array<Any>
    var project: Dictionary<String,Any>
    
    func getRoomName(_ room:Dictionary<String,Any>) -> String{
        return room["name"] as? String ?? ""
    }
    
    var body: some View {
            VStack {
                ForEach(self.rooms.indices, id: \.self) { i in
                    NavigationLink(destination:
                    RoomView(
                        room: self.rooms[i] as! Dictionary<String,Any>,
                        project: self.project)){
                            ListItem(
                                id: String(i),
                                title: self.getRoomName(self.rooms[i] as! Dictionary<String, Any>),
                                cost: 100
                            )
                        }
                }
                Spacer()
                .padding(.top,14)
                .navigationBarTitle(Text(project["name"] as! String),displayMode: .inline)
        }
    }
}
