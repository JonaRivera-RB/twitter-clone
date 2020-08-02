//
//  TweetController.swift
//  twitter-clone
//
//  Created by Misael Rivera on 24/06/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit


private let reuseIdentifier = "tweetCell"
private let reuseIdentifierHeader = "tweetHeader"

class TweetController: UICollectionViewController {
    
    //MARK: - Properties
    private var tweet: Tweet
    private var actionSheetLauncher: ActionSheetLauncher!
    
    private var replies = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        fetchReplies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    //MARK: - API
    func fetchReplies() {
        TweetService.shared.fetchReplies(fotTweet: tweet) { tweet in
            self.replies = tweet
        }
    }
    
    //MARK: - Helpers
    private func configureCollectionView() {
        //navigationController?.navigationBar.barStyle = .default
        //navigationController?.navigationBar.isHidden = false
        
        collectionView.backgroundColor = .white
        //collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifierHeader)
    }
    
    fileprivate func showActionSheet(forUser user: User) {
        actionSheetLauncher = ActionSheetLauncher(user: user)
        self.actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
}


//MARK: - CollectionViewDataSource
extension TweetController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = replies[indexPath.row]
        return cell
    }
    
}


//MARK: - UICollectionViewDelegateFlowLayout

extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let viewModel = TweetViewModel(tweet: tweet)
        let heigh = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: heigh + 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 120)
    }
}

//MARK: - UICollectionViewDelegate

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifierHeader, for: indexPath) as! TweetHeader
        header.tweet = tweet
        header.delegate = self
        return header
    }
}

//MARK: - TweetHeaderDelegate

extension TweetController: TweetHeaderDelegate {
    
    func showActionSheet() {
        if tweet.user.isCurrentUser {
            showActionSheet(forUser: tweet.user)
        }else {
            UserService.shared.checkIfTheUserIsFollowed(uid: tweet.user.uid) { isFollowed in
                var user = self.tweet.user
                user.isFollowed = isFollowed
                self.showActionSheet(forUser: user)
            }
        }
        
    }
}

//MARK: - ActionSheetLauncherDelegate

extension TweetController: ActionSheetLauncherDelegate {
    func didSelect(option: ActionsheetOptions) {
        switch option {
            
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { (err, ref) in
                print("did follow user \(user.username)")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { (err, ref) in
                print("did unfollow user \(user.username)")
            }
        case .report:
            print("did report user")
        case .delete:
            print("did delete user")
        }
    }
}
