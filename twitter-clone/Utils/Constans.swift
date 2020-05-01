//
//  Constans.swift
//  twitter-clone
//
//  Created by Misael Rivera on 01/05/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import Firebase

let DB_REF = Database.database().reference()
let DB_REF_USER = DB_REF.child("users")

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")
