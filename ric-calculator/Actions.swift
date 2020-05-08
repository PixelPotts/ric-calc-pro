import FirebaseAuth
import Combine

class User {
    var uid: String
    var email: String?
    var displayName: String?
    
    init(uid: String, displayName: String?, email: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
    }
}

class SessionStore : ObservableObject {
    
    func signUp(
        email: String,
        phoneNumber: String,
        displayName: String,
        handler: @escaping AuthDataResultCallback
    ) {
        // auth phone from firebase docs
        PhoneAuthProvider.provider().verifyPhoneNumber("+1"+phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // Sign in using the verificationID and the code sent to the user
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID!,
                verificationCode: "123456"
            )
            
            // Sign in with authentication token
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
//                print("User is signed in! (new)")
            }
        }
    }
}
