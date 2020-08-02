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
let REF_TWEETS = DB_REF.child("tweets")
let REF_USER_TWEETS = DB_REF.child("user-tweets")
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")
let REF_TWEET_REPLIES = DB_REF.child("tweet-replies")
let REF_USER_LIKES = DB_REF.child("user-likes")
let REF_TWEET_LIKES = DB_REF.child("tweet-likes")
let REF_NOTIFICATIONS = DB_REF.child("notifications")
let REF_USER_REPLIES = DB_REF.child("user-replies")
