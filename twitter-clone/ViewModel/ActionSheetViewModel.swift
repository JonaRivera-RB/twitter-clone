//
//  ActionsheetOptions.swift
//  twitter-clone
//
//  Created by Misael Rivera on 05/07/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import Foundation

struct ActionSheetViewModel {
    private let user: User
    
    var options: [ActionsheetOptions]  {
        var results = [ActionsheetOptions]()
        
        if user.isCurrentUser {
            results.append(.delete)
        }else {
            let followOption: ActionsheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
        }
        
        results.append(.report)
        return results
    }
    init(user: User) {
        self.user = user
    }
}

enum ActionsheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description: String {
        switch self {
        case .follow(let user): return "Follow \(user.username)"
        case .unfollow(let user): return "unFollow \(user.username)"
        case .report: return "report Tweet"
        case .delete: return "delete Tweet"
        }
    }
}
