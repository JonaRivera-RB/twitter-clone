//
//  AuthService.swift
//  twitter-clone
//
//  Created by Misael Rivera on 01/05/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(WithEmail email: String, withPassword password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping(_ success:Bool,_ error: Error?,_ references: DatabaseReference?) -> Void) {
        let email = credentials.email
        let password = credentials.password
        let username = credentials.username
        let fullname = credentials.fullname
        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else {
            completion(false, nil, nil)
            return }
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        
        
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child("\(filename).jgp")
        
        storageRef.putData(imageData, metadata: metaDataConfig) { (meta, error) in
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else {
                    completion(false, nil, nil)
                    return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error  {
                        print("DEBUG: Error is \(error.localizedDescription)")
                    }
                    
                    guard let uid = result?.user.uid else {
                        completion (false, nil, nil)
                        return }
                    let values = ["email": email, "username": username, "fullname": fullname, "profileImageUrl": profileImageUrl]
                    
                    DB_REF_USER.child(uid).onDisconnectUpdateChildValues(values) { (error, refence) in
                        completion(true, error, refence)
                    }
                }
            }
        }
    }
}
