//
//  EditProfileHeade.swift
//  twitter-clone
//
//  Created by Misael Rivera on 09/08/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit

protocol EditProfileHeaderProtocol: class {
    func didTapChangeProfilePhoto()
}

class EditProfileHeader: UIView {
    //MARK: - Properties
    
    private let user: User
    weak var delegate: EditProfileHeaderProtocol?
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 3.0
        
        return iv
    }()
    
    private let changeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Profile Image", for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfileImage), for: .touchUpInside)
        return button
    }()
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        
        backgroundColor = .twitterBlue
        
        addSubview(profileImageView)
        profileImageView.center(inView: self, yConstant: -16)
        profileImageView.setDimensions(width: 100, height: 100)
        profileImageView.layer.cornerRadius = 100 / 2
        
        addSubview(changeButton)
        changeButton.centerX(inView: self, topAnchor: profileImageView.bottomAnchor, paddingTop: 8)
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    //MARK: - Selectors
    @objc func handleChangeProfileImage() {
        delegate?.didTapChangeProfilePhoto()
    }
}
