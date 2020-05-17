//
//  RoomView.swift
//  ric-calculator
//
//  Created by Bryan Potts on 5/6/20.
//  Copyright © 2020 Bryan Potts. All rights reserved.
//
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

/// TODO:
/// Singleton shared DAO object
/// Try passing in entire collection
/// Check out nested codables

struct RoomView: View {
    var db = Firestore.firestore()
    var project: Dictionary<String,Any>
    var roomDocumentId: String
    @State var room: Dictionary<String,Any> = ["":[:]]
    @State var name: String = ""
    @State var hasInstall: Bool = false
    @State var hasTearout: Bool = false
    @State var hasMaterial: Bool = false
    @State var sqFtToInstall: String = ""
    @State var sqFtOfTearout: String = ""
    @State var yearHomeBuilt: String = ""
    @State var materialCost: String = ""
    @State var installMaterial: String = ""
    @State var tearoutMaterial: String = ""
    @State var total: String = "0.00"
    
    init(
        project: Dictionary<String,Any>,
        roomDocumentId: String
    ){
        self.project = project
        self.roomDocumentId = roomDocumentId
    }
    
    func getRoom(_ id:String) -> Void {
        self.db.collection("rooms").document(id).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
            } else {
                print("ROOM FROM DB:")
                let room = snapshot?.data()
                self.name = room!["name"] as? String ?? ""
                self.hasInstall = room!["hasInstall"] as? Bool ?? false
                self.hasTearout = room!["hasTearout"] as? Bool ?? false
                self.hasMaterial = room!["hasMaterial"] as? Bool ?? false
                self.sqFtToInstall = room!["sqFtToInstall"] as? String ?? ""
                self.sqFtOfTearout = room!["sqFtOfTearout"] as? String ?? ""
                self.yearHomeBuilt = room!["yearHomeBuilt"] as? String ?? ""
                self.materialCost = room!["materialCost"] as? String ?? ""
                self.installMaterial = room!["installMaterial"] as? String ?? ""
                self.tearoutMaterial = room!["tearoutMaterial"] as? String ?? ""
            }
        }
    }
    
    func saveRoom() -> Void {
        self.db.collection("rooms").document(self.roomDocumentId).updateData([
            "name": String(self.name),
            "hasInstall": Bool(self.hasInstall),
            "hasTearout": Bool(self.hasTearout),
            "hasMaterial": Bool(self.hasMaterial),
            "sqFtToInstall": self.sqFtToInstall,
            "sqFtOfTearout": self.sqFtOfTearout,
            "yearHomeBuilt": self.yearHomeBuilt,
            "materialCost": self.materialCost,
            "tearoutMaterial": self.tearoutMaterial,
            "installMaterial": self.installMaterial,
            "total": self.total,
        ], completion: { error in
            if let error = error {
                print(error)
            } else {
                let Calc = Calculator(
                    hasInstall: self.hasInstall,
                    hasTearout: self.hasTearout,
                    hasMaterial: self.hasMaterial,
                    sqFtToInstall: self.sqFtToInstall,
                    sqFtOfTearout: self.sqFtOfTearout,
                    yearHomeBuilt: self.yearHomeBuilt,
                    materialCost: self.materialCost,
                    installMaterial: self.installMaterial,
                    tearoutMaterial: self.tearoutMaterial
                )
                self.total = String(Calc.getFormattedTotal())
                print("total:",Calc.getTotal())
            }
        })
    }
    
    func isStringInArrayOfStrings(array: Array<String>, string: String) -> Bool {
        for item in array {
            if(item==string) {
                return true
            }
        }
        return false
    }
    
    func isTypeVisible(
        types: Array<String>,
        hasInstall: Binding<Bool>,
        hasMaterial: Binding<Bool>,
        hasTearout: Binding<Bool>
    ) -> Bool {
        if(hasInstall.wrappedValue==false && hasMaterial.wrappedValue==false && hasTearout.wrappedValue==false) {
            return false
        } else {
            if(types == [""]) { return true }
            if(isStringInArrayOfStrings(array: types, string: "install") && hasInstall.wrappedValue) { return true }
            if(isStringInArrayOfStrings(array: types, string: "material") && hasMaterial.wrappedValue) { return true }
            if(isStringInArrayOfStrings(array: types, string: "tearout") && hasTearout.wrappedValue) { return true }
            return false
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action:{
                    self.total = "0.00"
                    self.saveRoom()
                }){
                    Text("Update/Save")
                }
            }
            .padding(.bottom,-22)
            
            // ROOM NAME
            TextField(
                "Room Name",
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
            
            // If any type is visible, show the remainder of the form
            if(isTypeVisible(types: [""], hasInstall: $hasInstall, hasMaterial: $hasMaterial, hasTearout: $hasTearout)) {
                
                // Sq. Ft, Home Built
                HStack {
                    if(isTypeVisible(types: ["install","material"], hasInstall: $hasInstall, hasMaterial: $hasMaterial, hasTearout: $hasTearout)) {
                        Field(
                            title: "Sq. Ft. to Install",
                            placeholder: "0",
                            text: $sqFtToInstall
                        ).font(.headline)
                    }
                    if(isTypeVisible(types: ["install","tearout"], hasInstall: $hasInstall, hasMaterial: $hasMaterial, hasTearout: $hasTearout)) {
                        Field(
                            title: "Year Home Built",
                            placeholder: "YYYY",
                            text: $yearHomeBuilt
                        ).font(.headline)
                    }
                }
                
                // Install Material & Material Cost
                HStack {
                    if(isTypeVisible(types: ["install"], hasInstall: $hasInstall, hasMaterial: $hasMaterial, hasTearout: $hasTearout)) {
                        HStack {
                            PickerField(
                                title: "Install Type",
                                options: ["NAILED","GLUED","FLOATING","TILED","CARPETED"],
                                selection: self.$installMaterial
                            )
                            Spacer()
                        }
                    }
                    if(isTypeVisible(types: ["material"], hasInstall: $hasInstall, hasMaterial: $hasMaterial, hasTearout: $hasTearout)) {
                        Field(
                            title: "Material Cost",
                            placeholder: "0",
                            text: $materialCost
                        ).font(.headline)
                    }
                }
                
                // Teartout
                if(isTypeVisible(types: ["tearout"], hasInstall: $hasInstall, hasMaterial: $hasMaterial, hasTearout: $hasTearout)) {
                    HStack {
                        HStack {
                            PickerField(
                                title: "Tearout Type",
                                options: ["NAILED","GLUED","FLOATING","TILED","CARPETED"],
                                selection: self.$tearoutMaterial
                            )
                            Spacer()
                        }
                        Field(
                            title: "Sq. Ft. of Tearout",
                            placeholder: "0",
                            text: $sqFtOfTearout
                        ).font(.headline)
                    }
                }
                
                HStack {
                    Text("Total")
                        .font(.headline)
                    Spacer()
                    Text($total.wrappedValue)
                }
                
//                Button("Update Total", action: {
//                    self.total = "0.00"
//                    self.saveRoom()
//                })
//                    .buttonStyle(NeumorphicButtonStyle(bgColor: Color.blue))
//                    .frame(minWidth:0, maxWidth: .infinity)
//                    .padding(.top,40)
                
            } else {
                Text("Get an accurate quote!").font(.title)
                    .padding(.bottom, 15)
                Text("Select the relevant options above and carefully enter your information. To have your quote verified simply save this room and someone from our sales team will contact you within 1 business day.")
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
            .padding(20)
            .background(Color("yellow"))
            .navigationBarTitle(Text(self.name), displayMode: .inline)
            .onAppear(){
                self.getRoom(self.roomDocumentId)
            }
    }
}

struct PickerField: View {
    @State var title: String = ""
    @State var options: Array<String> = [""]
    @Binding var selection: String
    @State var presenting: Bool = false
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            Button(action: {self.presenting.toggle()}){
                Text(self.$selection.wrappedValue)
                    .padding(.top,7)
                    .padding(.bottom,7)
            }
        }
        .onTapGesture {
            self.presenting = true
        }
        .sheet(isPresented: self.$presenting) {
            PickerView(
                selection: self.$selection,
                options: self.options,
                title: self.title
            )
        }
    }
}

struct PickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selection: String
    @State var localSelection: Int = 0
    var options: Array<String>
    var title: String
    var body: some View {
        VStack {
            Picker(selection: self.$localSelection, label: Text(self.title)) {
                ForEach(0 ..< self.options.count) {
                    Text(self.options[$0])
                }
            }
            .labelsHidden()
            Button(action: {
                self.selection = self.options[self.localSelection]
                print(self.selection)
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Select")
            }
            Spacer()
        }
    }
}
