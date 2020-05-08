

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// Er7xdOCsadaz5rUOrMl0xhX3sEF3

struct AllProjects: View {
    @State var projects: [String:Any] = [:]
    @State var showAddProjectSheet: Bool = false
    let db = FirebaseFirestore.Firestore.firestore()
    
    func seedProjects() {
        let ref = self.db.collection("projects")
        ref.addDocument(data: [
            "_createdBy": "Er7xdOCsadaz5rUOrMl0xhX3sEF3",
            "_dateCreated": NSDate().timeIntervalSince1970,
            "title": "Potts Living, Dining Room",
            "rooms": [
                "Living Room": [
                    "hasInstall": true,
                    "hasTearout": true,
                    "hasMaterial": true,
                    "sqFtToInstall": Int16(1001),
                    "yearHomeBuilt": Int16(1918),
                    "materialCost": Double(7.95),
                    "tearoutMaterial": Int8(1),
                    "sqFtOfTearout": Int16(101),
                    "_dateCreated": NSDate().timeIntervalSince1970,
                    "_createdBy": "Er7xdOCsadaz5rUOrMl0xhX3sEF3",
                ],
                "Dining Room": [
                    "hasInstall": true,
                    "hasTearout": false,
                    "hasMaterial": false,
                    "sqFtToInstall": Int16(1001),
                    "yearHomeBuilt": Int16(1918),
                    "materialCost": Double(7.95),
                    "tearoutMaterial": Int8(1),
                    "sqFtOfTearout": Int16(101),
                    "_dateCreated": NSDate().timeIntervalSince1970,
                    "_createdBy": "Er7xdOCsadaz5rUOrMl0xhX3sEF3",
                ],
                
            ]
        ])
        ref.addDocument(data: [
            "_createdBy": "Er7xdOCsadaz5rUOrMl0xhX3sEF3",
            "_dateCreated": NSDate().timeIntervalSince1970,
            "title": "Big Tuna's Warehouse",
            "rooms": [
                "Small Warehouse": [
                    "hasInstall": true,
                    "hasTearout": true,
                    "hasMaterial": true,
                    "sqFtToInstall": Int16(1001),
                    "yearHomeBuilt": Int16(1918),
                    "materialCost": Double(7.95),
                    "tearoutMaterial": Int8(1),
                    "sqFtOfTearout": Int16(101),
                    "_dateCreated": NSDate().timeIntervalSince1970,
                    "_createdBy": "Er7xdOCsadaz5rUOrMl0xhX3sEF3",
                ],
                "Big Warehouse": [
                    "hasInstall": true,
                    "hasTearout": false,
                    "hasMaterial": false,
                    "sqFtToInstall": Int16(1001),
                    "yearHomeBuilt": Int16(1918),
                    "materialCost": Double(7.95),
                    "tearoutMaterial": Int8(1),
                    "sqFtOfTearout": Int16(101),
                    "_dateCreated": NSDate().timeIntervalSince1970,
                    "_createdBy": "Er7xdOCsadaz5rUOrMl0xhX3sEF3",
                ],
                
            ]
        ])
        
    }
    
    func getProjects(){
        let ref = self.db.collection("projects").whereField("_createdBy", isEqualTo: Auth.auth().currentUser!.uid as String)
        ref.addSnapshotListener { (snapshot, error) in
            if(snapshot!.isEmpty){
                return
            }
            
        }
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                Group {
                    if(self.projects.count < 1){
                        Text("No projects have been added yet!")
                        Button(action:{ self.showAddProjectSheet.toggle() }) {
                            Text("+ Add my first project")
                        }
                        .padding(20)
                    }
                }
//                ForEach(0..<projects.count) { project in
//                    NavigationLink(destination: ProjectView(project: projects[project])){
//                        ListItem(
//                            id: projects[project]["id"] as! String,
//                            title: projects[project]["title"] as! String,
//                            cost: projects[project]["cost"] as! Int
//                        )
//                    }
//                }
                
                Spacer()
                Button(action:{
                    _ = try! Auth.auth().signOut()
                }){
                    Text("Sign Out")
                }
                .padding(20)
            }
            .padding(.top,14)
            .navigationBarTitle(Text("All Projects"),displayMode: .inline)
            .sheet(isPresented: self.$showAddProjectSheet) {
                VStack {
                    Text("Add New Project").font(.title)
                    
                    FloatingF
                    
                    Spacer()
                }
            }
        }
    }
}
