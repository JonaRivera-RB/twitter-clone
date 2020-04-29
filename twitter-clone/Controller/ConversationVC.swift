//
//  ConversationVC.swift
//  twitter-clone
//
//  Created by Misael Rivera on 28/04/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit

class ConversationVC: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    //MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }
    
}
