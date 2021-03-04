//
//  AuthService.swift
//  Collect
//
//  Created by Patrick Ortell on 1/25/21.
//

import UIKit
import Firebase

struct AuthCreds {
    let email:String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
    
}


struct AuthService {
    
    static func loginUserIn(withEmail email: String, password: String, completion:
        AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredentials credentials: AuthCreds, completion: @escaping(Error?) -> Void){
        ImageUploader.uploadImage(image: credentials.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password){
                (result, error) in
                if let error = error {
                    print("DEBUG: failed to register user")
                    return
                }
                
                guard let uid = result?.user.uid else {return}
                
                let data: [String: Any] = ["email": credentials.email, "fullname": credentials.fullname, "username": credentials.username, "profileImageUrl": imageUrl, "uid": uid]
                
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }
        }
    }
}
