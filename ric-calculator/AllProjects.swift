

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// Er7xdOCsadaz5rUOrMl0xhX3sEF3

func ??<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
    return Binding(get: {
        binding.wrappedValue ?? fallback
    }, set: {
        binding.wrappedValue = $0
    })
}

class Projects : ObservableObject {
    @Published var projects: Array<[String:Any]> = []
    private var projectsTmp: Array<[String : Any]> = []
    let db = FirebaseFirestore.Firestore.firestore()
    func addItem(_ project: [String:Any]){
        projects.append(project)
    }
    func updateProjects() -> Void {
        let ref = self.db.collection("projects").whereField("_createdBy", isEqualTo: Auth.auth().currentUser!.uid as String)
        ref.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
            }
            if(snapshot!.isEmpty){
                print("snapshot is empty!")
                return
            }
            for document in snapshot!.documents {
                self.projectsTmp.append(document.data())
            }
            self.projects = self.projectsTmp
        }
    }
    func count() -> Int {
        return projects.count
    }
    func getItem(_ i:Int) -> [String:Any] {
        return projects[i]
    }
}

struct AllProjects: View {
    @ObservedObject var projects = Projects()
    @State var showAddProjectSheet: Bool = false
    @State var newProjectName: String?
    let db = FirebaseFirestore.Firestore.firestore()
    
    
    func seedProjects() {
        let ref = self.db.collection("projects")
        ref.addDocument(data: [
            "_createdBy": "Er7xdOCsadaz5rUOrMl0xhX3sEF3",
            "_dateCreated": NSDate().timeIntervalSince1970,
            "name": "Potts Living, Dining Room",
            "rooms": [
                [
                    "name": "Living Room",
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
                [
                    "name": "Dining Room",
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
                ]
            ]
        ])
        ref.addDocument(data: [
            "_createdBy": "Er7xdOCsadaz5rUOrMl0xhX3sEF3",
            "_dateCreated": NSDate().timeIntervalSince1970,
            "name": "Big Tuna Properties",
            "rooms": [
                [
                    "name": "Big Warehouse",
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
                [
                    "name": "Small Warehouse",
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
                ]
            ]
        ])
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                Group {
                    if(self.projects.count() < 1){
                        Text("No projects have been added yet!")
                        Button(action:{ self.showAddProjectSheet.toggle() }) {
                            Text("+ Add my first project")
                        }
                        .padding(20)
                    }
                }
                ScrollView {
                    ForEach(self.$projects.projects.wrappedValue.indices, id: \.self) { i in
                        NavigationLink(destination: ProjectView(
                            rooms: self.projects.getItem(i)["rooms"] as? Array<Any> ?? [],
                            project: self.projects.getItem(i)
                        )){
                            ListItem(
                                id: self.projects.getItem(i)["name"] as? String ?? "",
                                title: self.projects.getItem(i)["name"] as? String ?? "",
                                cost: 100
                            )
                                .frame(height:40)
                        }
                    }
                    if(self.projects.count() > 0){
                        Button(action:{ self.showAddProjectSheet.toggle() }) {
                            HStack{
                                Text("+ New Project")
                                Spacer()
                            }
                        }
                        .padding(.leading,14)
                        .padding(.top,10)
                    }
                    Spacer()
                }
                
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
                AddProjectView(newProjectName: self.$newProjectName)
            }
            .onAppear(){
                self.projects.updateProjects()
            }
        }
    }
}

struct AddProjectView: View {
    
    func addProject(_ name:String?){
        Firestore.firestore().collection("projects").addDocument(data: [
            "_createdBy": "Er7xdOCsadaz5rUOrMl0xhX3sEF3",
            "_dateCreated": NSDate().timeIntervalSince1970,
            "name": "Potts Living, Dining Room",
            "rooms": [
                [
                    "name": name ?? "My Cool Project ",
                    "hasInstall": true,
                    "hasTearout": true,
                    "hasMaterial": true,
                    "sqFtToInstall": Int16(0),
                    "yearHomeBuilt": Int16(0),
                    "materialCost": Double(0.00),
                    "tearoutMaterial": Int8(0),
                    "sqFtOfTearout": Int16(0),
                    "_dateCreated": NSDate().timeIntervalSince1970,
                    "_createdBy": Auth.auth().currentUser!.uid,
                ]
            ]
        ]) { error in
            if let error = error {
                print(error)
            } else {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var newProjectName: String?
    var body: some View {
        VStack {
            Text("Add New Project").font(.title)
            TextField("Living & Dining Room", text: self.$newProjectName ?? "")
            Button(action: {
                self.addProject(self.$newProjectName.wrappedValue)
            }){
                Text("Submit")
                    .padding(.top,30)
            }
            Spacer()
        }
        .padding(20)
    }
}