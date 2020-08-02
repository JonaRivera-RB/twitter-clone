//
//  ProfileV.swift
//  twitter-clone
//
//  Created by Misael Rivera on 25/05/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit

private let reuseIdentifier = "tweetCell"
private let reuseIdentifierHeader = "profileHeader"

class ProfileVC: UICollectionViewController {
    //MARK: - Properties
    private var user: User
    
    private var selectedFilters: ProfileFilterOptions = .tweets {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var tweets = [Tweet]()
    private var likedTweets = [Tweet]()
    private var replies = [Tweet]()
    
    private var currentDataSource: [Tweet] {
        switch selectedFilters {
        case .tweets: return tweets
        case .likes: return likedTweets
        case .replies: return replies
        }
    }
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweets()
        fetchLikedTweets()
        fetchReplies()
        checkIfTheUserIsFollowed()
        fetchUserStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    //MARK: - API
    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
            self.collectionView.reloadData()
        }
    }
    
    func fetchLikedTweets() {
        TweetService.shared.fetchLikes(forUser: user) { tweets in
            self.likedTweets = tweets
        }
    }
    
    func fetchReplies() {
        TweetService.shared.fetchReplies(forUser: user) { tweet in
            self.replies = tweet
            
            self.replies.forEach { reply in
                
            }
        }
    }
    
    func checkIfTheUserIsFollowed() {
        UserService.shared.checkIfTheUserIsFollowed(uid: user.uid) { (isFollowed) in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStatus() {
        UserService.shared.fetchUserStatus(uid: user.uid) { userRelationStatus in
            self.user.status = userRelationStatus
            self.collectionView.reloadData()
        }
    }
    
    func configureCollectionView() {
        view.backgroundColor = .white
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifierHeader)
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tabHeight
    }
}

extension ProfileVC {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifierHeader, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: currentDataSource[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ProfileVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = currentDataSource[indexPath.row]
        return cell
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension ProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: currentDataSource[indexPath.row])
        var heigh = viewModel.size(forWidth: view.frame.width).height + 72
        
        if currentDataSource[indexPath.row].isReply {
            heigh += 20
        }
        return CGSize(width: view.frame.width, height: heigh)
    }
}

//MARK: - ProfileHeaderDelegate
extension ProfileVC: ProfileHeaderDelegate {
    func didSelect(filter: ProfileFilterOptions) {
        self.selectedFilters = filter
    }
    
    func handleEdithProfileFollow(_ header: ProfileHeader) {
        
        if user.isCurrentUser {
            print("Show edit profile")
            return
        }
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { (error, ref) in
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
        }else {
            UserService.shared.followUser(uid: user.uid) { (error, ref) in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                
                NotificationService.shared.uploadNotification(type: .follow, tweet: nil, user: self.user)
            }
        }
    }
    
    func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
}
