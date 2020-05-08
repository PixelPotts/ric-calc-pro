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
    var project: Dictionary<String,Any>
    var body: some View {
            VStack {
                ForEach(0..<rooms.count) { room in
                    NavigationLink(destination: RoomView(id: rooms[room]["id"] as! String)){
                        ListItem(
                            id: rooms[room]["id"] as! String,
                            title: rooms[room]["title"] as! String,
                            cost: rooms[room]["cost"] as! Int
                        )
                    }
                }
                Spacer()
                .padding(.top,14)
                .navigationBarTitle(Text(project["title"] as! String),displayMode: .inline)
        }
    }
}
