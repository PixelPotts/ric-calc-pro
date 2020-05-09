import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Combine

struct ContentView: View {
    @State var session: Any?
    @State var showTermSheet = false
    @State var phoneNumber: String = ""
    @State var displayName: String = ""
    @State var emailAddress: String = ""
    
    init(){
        print("ContentView().init() fired!")
//        self.getUser()
    }
    
    func getUser () {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.session = User(
                    uid: user.uid,
                    displayName: user.displayName,
                    email: user.email
                )
            } else {
                self.session = nil
            }
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                
                // MARK: - SIGN IN or REGISTER
                if(self.session == nil){
                    
                    Group {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width / 2)

                        Text("AccuQuote Calculator").padding(.top,10)

                        // Full Name
                        FloatingLabelInput(placeholder: "First and Last Name", value: self.$displayName)
                            .keyboardType(.alphabet)
                            .autocapitalization(.words)
                            .onReceive(Just(self.displayName)) { newValue in
                                let filtered = newValue.filter {" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRST".contains($0)}
                                if filtered != newValue { self.displayName = filtered }
                                self.displayName = self.displayName.replacingOccurrences(of: "  ", with: " ")
                        }
                        .padding(.top, 10)

                        // Email
                        FloatingLabelInput(placeholder: "Email Address", value: self.$emailAddress).autocapitalization(.none)

                        // Phone Number
                        FloatingLabelInput(placeholder: "Phone Number", value: self.$phoneNumber)
                            .keyboardType(.numberPad)
                            .onReceive(Just(self.phoneNumber)) { newValue in
                                let filtered = newValue.filter {" -+0123456789".contains($0)}
                                if filtered != newValue {
                                    self.phoneNumber = filtered
                                }
                                self.phoneNumber = self.phoneNumber.replacingOccurrences(of: "  ", with: " ")
                        }

                        Button(action: {
                            if(validatePhoneNumber(value: self.$phoneNumber)) {
                                SessionStore().signUp(
                                    email: self.$emailAddress.wrappedValue,
                                    phoneNumber: self.$phoneNumber.wrappedValue,
                                    displayName: self.$displayName.wrappedValue) { (AuthDataResult, Error) in
                                        print(Error!)
                                }
                            }
                        }) {
                            Text("Register / Sign In")
                        }

                        Spacer()

                        Button(action: {
                            self.showTermSheet.toggle()
                        }) {
                            Text("Terms of Use")
                        }.sheet(isPresented: self.$showTermSheet) {
                            TermsSheet()
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                    .frame(minWidth:100, maxWidth: .infinity)
                    .padding(.all,20)
                    
                    // MARK: - CALCULATOR HOMEPAGE (All Projects)
                } else {
                    AllProjects()
                }
            }
            .onAppear(){
                self.getUser()
                print("ContentView().onAppear() fired!")
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
