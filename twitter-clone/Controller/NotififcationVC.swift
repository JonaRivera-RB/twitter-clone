//
//  NotififcationVC.swift
//  twitter-clone
//
//  Created by Misael Rivera on 28/04/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit

private var reuseIdentifier = "NotificationCell"
class NotififcationVC: UITableViewController {
    
    //MARK: - Properties
    private var notifications = [Notificacion]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    //MARK: - Selectors
    @objc func handleRefresh() {
        fetchNotifications()
    }
    
    //MARK: - API
    private func fetchNotifications() {
        refreshControl?.beginRefreshing()
        
        NotificationService.shared.fetchNotifications { notifications in
            self.refreshControl?.endRefreshing()
            self.notifications = notifications
            self.checkIfTheUserIsFollowed(notifications: notifications)
        }
    }
    
    private func checkIfTheUserIsFollowed(notifications: [Notificacion]) {
        for (index, notification) in notifications.enumerated() {
            if case .follow = notification.type {
                let user = notification.user
                
                UserService.shared.checkIfTheUserIsFollowed(uid: user.uid) { isFollowed in
                    self.notifications[index].user.isFollowed = isFollowed
                }
            }
        }
    }
    
    //MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
}

//MARK: - NotififcationVC
extension NotififcationVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        
        guard let id = notification.tweetID else { return }
        TweetService.shared.fetchTweet(withTweetID: id) { tweet in
            let controller = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

//MARK: - NotificationCellDelegate
extension NotififcationVC: NotificationCellDelegate {
    func didTapFollowbutton(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { err, ref in
                cell.notification?.user.isFollowed = false
            }
        }else {
            UserService.shared.followUser(uid: user.uid) { err, ref in
                cell.notification?.user.isFollowed = true
            }
        }
    }
    
    func didTapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        
        let controller = ProfileVC(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
