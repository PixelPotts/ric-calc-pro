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

class Selections: ObservableObject {
    @Published var installMaterial: String = ""
}

struct RoomView: View {
    @State private var project: Dictionary<String,Any> = ["":[:]]
    @State private var docID: String = ""
    @State private var name: String = ""
    @State private var hasInstall = false
    @State private var hasTearout = false
    @State private var hasMaterial = false
    @State private var sqFtToInstall: String = ""
    @State private var yearHomeBuilt: String = ""
    @State private var materialCost: String = ""
    @State private var installMaterial: String = "SELECT"
    @State private var tearoutMaterial: String = "SELECT"
    @State private var sqFtOfTearout: String = ""
    @State private var total: String = "0.00"
    
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
    
    func isStringInArrayOfStrings(array: Array<String>, string: String) -> Bool {
        print("isStringInArrayOfStrings() fired!")
        print(array)
        for item in array {
            if(item==string) {
                print("found matcing string for", item, string)
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
        // if no types are switched on, return false
        print("---")
        print("types", types)
        
        if(hasInstall.wrappedValue==false && hasMaterial.wrappedValue==false && hasTearout.wrappedValue==false) {
            print("No options are switched on! Returning false.")
            return false
        } else {
            
            if(types == [""]) { return true }
            print("At least one option is switched on.")
            
            print(isStringInArrayOfStrings(array: types, string: "install"))
            
            if(isStringInArrayOfStrings(array: types, string: "install") && hasInstall.wrappedValue) { return true }
            if(isStringInArrayOfStrings(array: types, string: "material") && hasMaterial.wrappedValue) { return true }
            if(isStringInArrayOfStrings(array: types, string: "tearout") && hasTearout.wrappedValue) { return true }
            
            print("Fallthrough returns false.")
            return false
        }
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
            
            // If any type is visible, show the remainder of the form
            if(isTypeVisible(types: [""], hasInstall: $hasInstall, hasMaterial: $hasMaterial, hasTearout: $hasTearout)) {
                
                // Sq. Ft, Home Built
                HStack {
                    if(isTypeVisible(types: ["install","material"], hasInstall: $hasInstall, hasMaterial: $hasMaterial, hasTearout: $hasTearout)) {
                        Field(
                            title: "Sq. Ft. of Material",
                            placeholder: "0",
                            text: $sqFtToInstall
                        )
                    }
                    if(isTypeVisible(types: ["install","tearout"], hasInstall: $hasInstall, hasMaterial: $hasMaterial, hasTearout: $hasTearout)) {
                        Field(
                            title: "Year Home Built",
                            placeholder: "YYYY",
                            text: $yearHomeBuilt
                        )
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
                        )
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
                        )
                    }
                }
                
                HStack {
                    Text("Total")
                    Spacer()
                    Text($total.wrappedValue)
                }
                
                Button("Save Room", action: {
                    
                })
                    .buttonStyle(NeumorphicButtonStyle(bgColor: Color.blue))
                    .frame(minWidth:0, maxWidth: .infinity)
                    .padding(.top,40)
                
            } else {
                Text("Get an accurate quote!").font(.title)
                    .padding(.bottom, 15)
                Text("Select the relevant options above and carefully enter your information. To have your quote verified simply save this room and someone from our sales team will contact you within 1 business day.")
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(20)
        .navigationBarTitle(Text("test"), displayMode: .inline)
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

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView(room: ["":""], project: ["":""])
    }
}
