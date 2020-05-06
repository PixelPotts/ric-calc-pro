//
//  ContentView.swift
//  ric-calculator
//
//  Created by Bryan Potts on 5/5/20.
//  Copyright © 2020 Bryan Potts. All rights reserved.
//

import SwiftUI

var projects: [Dictionary<String,Any>] = [
    [
        "id": "A00001",
        "title": "Smith Living, Dining Room",
        "cost": 530
    ],
    [
        "id": "A00002",
        "title": "Johnson Bathrooms",
        "cost": 1200
    ],
    [
        "id": "A00003",
        "title": "Potts Kitchen and Bath",
        "cost": 940
    ]
]

struct ContentView: View {
    @State var scene = "projects"
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                ForEach(0..<projects.count) { project in
                    NavigationLink(destination: ProjectView(project: projects[project])){
                        ListItem(
                            id: projects[project]["id"] as! String,
                            title: projects[project]["title"] as! String,
                            cost: projects[project]["cost"] as! Int
                        )
                    }
                }
                
                Spacer()
            }
            .padding(.top,14)
            .navigationBarTitle(Text("All Projects"),displayMode: .inline)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
