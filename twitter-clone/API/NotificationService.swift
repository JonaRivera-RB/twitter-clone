//
//  NotificationService.swift
//  twitter-clone
//
//  Created by Misael Rivera on 12/07/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(toUser user: User, type: NotificationType, tweetID: String? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        
        if let tweetID = tweetID {
            values["tweetID"] = tweetID
        }
        
        REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
    }
    
    func fetchNotifications(completion: @escaping([Notificacion]) -> Void) {
        var notifications = [Notificacion]()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_NOTIFICATIONS.child(uid).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                completion(notifications)
            }else {
                REF_NOTIFICATIONS.child(uid).observe(.childAdded) { snapshot in
                    guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                    guard let uid = dictionary["uid"] as? String else { return }
                    
                    UserService.shared.fetchUser(uid: uid) { user in
                        let notification = Notificacion(user: user, tweet: nil, dictionary: dictionary)
                        notifications.append(notification)
                        completion(notifications)
                    }
                }
            }
        }
        
    }
}
