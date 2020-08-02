//
//  ProfileFilterOptions.swift
//  twitter-clone
//
//  Created by Misael Rivera on 27/05/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    private let user: User
    let username: String
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: user.status?.followers ?? 0, text: "followers")
    }
    
    var followinfString: NSAttributedString? {
        return attributedText(withValue: user.status?.following ?? 0, text: "followings")
    }
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        if !user.isFollowed && !user.isCurrentUser {
            return "Follow"
        }
        
        if user.isFollowed {
            return "Following"
        }
        
        return ""
    }
    
    init(user: User) {
        self.user = user
        self.username = "@" + user.username
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: "\(text)", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
}
