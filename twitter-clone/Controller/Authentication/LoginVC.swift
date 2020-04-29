//
//  LoginVC.swift
//  twitter-clone
//
//  Created by Misael Rivera on 28/04/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    //MARK: - Properties
    private let logoImageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "TwitterLogo")
        return iv
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utilities().inputContainerView(withImage: image, textfield: emailTextField)
        return view
    }()
    
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textfield: passwordTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilities().textfield(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textfield(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Don't have an account", " Sign Up")
        button.addTarget(self, action: #selector(handleSingUp), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    
    @objc func handleLogin() {
        print("login button")
    }
    
    @objc func handleSingUp() {
        let registrationVC = RegistrationVC()
        navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageview)
        logoImageview.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageview.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: logoImageview.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingBottom: 16, paddingRight: 40)
    }
}
