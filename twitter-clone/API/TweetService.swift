//
//  TweetService.swift
//  twitter-clone
//
//  Created by Misael Rivera on 13/05/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(cation: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [ "uid": uid,
                       "timestamp": Int(NSDate().timeIntervalSince1970),
                        "likes": 0,
                        "retweets": 0,
                        "caption": cation] as [String: Any]
        
        REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
}
