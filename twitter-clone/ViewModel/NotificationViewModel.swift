//
//  NotificationViewModel.swift
//  twitter-clone
//
//  Created by Misael Rivera on 25/07/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit

struct NotificationViewModel {
    
    private var notification: Notificacion
    private var type: NotificationType
    private var user: User
    
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now) ?? "2m"
    }
    
    var notificationMessage: String {
        switch type {
        case .follow: return " started following you"
        case .like: return " liked you tweet"
        case .reply: return " replied to your tweet"
        case .retweet: return " retweeted your tweet"
        case .mention: return " mentioned you in a tweet"
        }
    }
    
    var notificationText: NSAttributedString? {
        guard let timestamp = timestampString else { return nil}
        
        let attibutedText = NSMutableAttributedString(string: user.fullname,
                                                      attributes: [.font : UIFont.boldSystemFont(ofSize: 12)])
        
        attibutedText.append(NSAttributedString(string: notificationMessage, attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        
        attibutedText.append(NSAttributedString(string: " - \(timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        
        return attibutedText
    }
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var shouldHideFollowButton: Bool {
        return  type != .follow
    }
    
    var followButtonText: String {
        return user.isFollowed ? "Following" : "Follow"
    }
    
    init(notification: Notificacion) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
