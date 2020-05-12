//
//  Project.swift
//  ric-calculator
//
//  Created by Bryan Potts on 5/6/20.
//  Copyright © 2020 Bryan Potts. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProjectView: View {
    var project: Dictionary<String,Any>
    @State var rooms: Array<Any> = []
    @State var showAddRoomSheet: Bool = false
    @State var newRoomName: String?
    var db = Firestore.firestore()
    
    func getRoomDictValueByKey(room: Dictionary<String,Any>, key: String) -> String{
        return room[key] as? String ?? "error_unknown_document_id"
    }
    
    func getKeyValue(_ list:Any, _ key:String) -> Any {
        for (k,v) in list as! Dictionary<String,Any> {
            if(k==key){ return v }
        }
        return ""
    }
    
    //MARK: - GET ROOMS
    func getRooms(){
        print("getRooms() fired!")
        let projectDocID = self.project["docID"] as? String ?? "bad_projectDocID"
        db.collection("rooms").whereField("_projectDocID", isEqualTo: projectDocID).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("getRooms() returned an error:", error)
            } else {
                var tmpRooms: Array<Any> = []
                _ = snapshot?.documents.map({ (QueryDocumentSnapshot) in
                    var data = QueryDocumentSnapshot.data()
                    data["_documentID"] = QueryDocumentSnapshot.documentID
                    print(data)
                    tmpRooms.append(data)
                })
                self.rooms = tmpRooms
            }
        }
    }
    
    //MARK: - ROOMS LIST
    var body: some View {
        VStack {
            if(self.rooms.count > 0){
                ForEach(self.rooms.indices, id: \.self) { i in
                    NavigationLink(destination:
                        RoomView(
                            project: self.project,
                            roomDocumentId: self.getRoomDictValueByKey(
                                room: self.rooms[i] as? Dictionary<String,Any> ?? ["":[:]],
                                key: "_documentID"
                            )
                        )
                    ){
                        ListItem(
                            id: String(i),
                            title: self.getRoomDictValueByKey(
                                room: self.rooms[i] as? Dictionary<String,Any> ?? ["":[:]],
                                key: "name"
                            ),
                            cost: 100
                        )
                    }
                }
            }
            
            Button(action:{ self.showAddRoomSheet.toggle() }) {
                HStack{
                    Text("+ Add Room")
                    Spacer()
                }
            }
            .padding(.leading,14)
            .padding(.top,10)
            .sheet(isPresented: self.$showAddRoomSheet) {
                AddRoomView(newRoomName: self.$newRoomName, project: self.project)
            }
            
            Spacer()
                .padding(.top,14)
                .navigationBarTitle(Text(project["name"] as! String),displayMode: .inline)
        }
        .onAppear(){
            self.getRooms()
        }
    }
}

//MARK: - ADD ROOM
struct AddRoomView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var newRoomName: String?
    var project: Dictionary<String,Any>
    var db = Firestore.firestore()
    
    func addRoom(_ name:String?){
        let randomName = "My Room #"+String(Int.random(in: -1...10001))
        let roomRef = self.db.collection("rooms").document()
        roomRef.setData([
            "name": self.newRoomName ?? randomName,
            "hasInstall": false,
            "hasTearout": false,
            "hasMaterial": false,
            "sqFtToInstall": Int16(0),
            "sqFtOfTearout": Int16(0),
            "yearHomeBuilt": Int16(0),
            "materialCost": Double(0),
            "tearoutMaterial": "GLUED",
            "installMaterial": "NAILED",
            "total": Double(0),
            "_projectDocID": self.project["docID"] as? String ?? "_projectDocID",
            "_createdOn": Int32(NSDate().timeIntervalSince1970),
            "_createdBy": Auth.auth().currentUser!.uid
        ]) { error in
            if let error = error {
                print(error)
            } else {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Add New Room").font(.title)
            TextField("Living & Dining Room", text: self.$newRoomName ?? "")
            Button(action: {
                self.addRoom(self.$newRoomName.wrappedValue)
            }){
                Text("Submit")
                    .padding(.top,30)
            }
            Spacer()
        }
        .padding(20)
    }
    
}
