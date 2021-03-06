//
//  UserService.swift
//  twitter-clone
//
//  Created by Misael Rivera on 02/05/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        DB_REF_USER.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUsers( completion: @escaping([User]) -> Void) {
        var users = [User]()
        
        DB_REF_USER.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(uid: String, completion: @escaping (DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid:1]) {(err, ref) in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }
    
    func unfollowUser(uid: String, completion: @escaping (DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { (error, ref) in
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfTheUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStatus(uid: String, completion: @escaping(userRelationStatus) -> Void) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let followers = snapshot.children.allObjects.count
            

            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { (snapshot) in
                let following = snapshot.children.allObjects.count
                
                let status = userRelationStatus(following: following, followers: followers)
                completion(status)
            }

        }
    }
    
    func fetchUser(withusername username: String, completion:@escaping(User) -> Void ) {
        REF_USER_USERNAMES.child(username).observeSingleEvent(of: .value) { snapshot in
            guard let uid = snapshot.value as? String else { return }
            self.fetchUser(uid: uid, completion: completion)
        }
    }
}
