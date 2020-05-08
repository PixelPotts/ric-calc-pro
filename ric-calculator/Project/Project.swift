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
    var body: some View {
            VStack {
                ForEach(self.rooms.indices, id: \.self) { i in
                    NavigationLink(destination: RoomView(String(i))){
                        ListItem(
                            id: String(i),
                            title: String(i),
                            cost: 100
                        )
                    }
                }
                Spacer()
                .padding(.top,14)
                .navigationBarTitle(Text(project["title"] as! String),displayMode: .inline)
        }
    }
}
