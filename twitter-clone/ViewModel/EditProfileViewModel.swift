//
//  EditProfileOptions.swift
//  twitter-clone
//
//  Created by Misael Rivera on 09/08/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit

enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case username
    case bio
    
    var description: String {
        switch self {
        case .fullname: return "Fullname"
        case .username: return "Username"
        case .bio: return "Bio"
        }
    }
}


