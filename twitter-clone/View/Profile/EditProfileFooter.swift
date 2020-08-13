//
//  EditProfileFooter.swift
//  twitter-clone
//
//  Created by Misael Rivera on 10/08/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit

protocol EditProfilefooterDelegate: class {
    func handleLogout()
}

class EditProfileFooter: UIView {
    
    //MARK: - Properties
    weak var delegate: EditProfilefooterDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoutButton)
        logoutButton.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 16)
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleLogout() {
        delegate?.handleLogout()
    }
}
