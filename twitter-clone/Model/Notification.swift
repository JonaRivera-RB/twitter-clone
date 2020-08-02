//
//  Notification.swift
//  twitter-clone
//
//  Created by Misael Rivera on 12/07/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notificacion {
    var tweetID: String?
    var timestamp: Date!
    var user: User
    var tweet: Tweet?
    var type: NotificationType!
    
    init(user: User, tweet: Tweet?, dictionary: [String: AnyObject]) {
        self.user = user
        self.tweet = tweet
        
        if let tweetID = dictionary["tweetID"] as? String {
            self.tweetID = tweetID
        }
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
