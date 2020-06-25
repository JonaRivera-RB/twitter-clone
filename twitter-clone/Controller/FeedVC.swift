//
//  FeedVC.swift
//  twitter-clone
//
//  Created by Misael Rivera on 28/04/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "tweetCell"

class FeedVC: UICollectionViewController {
    
    //MARK: - Properties
    var user: User? {
        didSet {
            configureLeftBarButton()
        }
    }
    
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        getchTweets()
    }
    
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         
        navigationController?.navigationBar.barStyle = .default
         navigationController?.navigationBar.isHidden = false
     }
    
    //MARK: - API
    private func getchTweets() {
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets
        }
    }
    
    //MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
    }
    
    private func configureLeftBarButton() {
        guard let user = user else { return }
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}

//MARK: - FeedVC
extension FeedVC {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension FeedVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 120)
    }
}


//MARK: - TweetCellDelegate
extension FeedVC: TweetCellDelegate {
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else { return }
        let controller = ProfileVC(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
