//
//  ProfileFilterCell.swift
//  twitter-clone
//
//  Created by Misael Rivera on 27/05/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var option: ProfileFilterOptions! {
        didSet { titleLabel.text = option.description }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Test filter"
        label.textColor = .lightGray
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
            titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.center(inView: self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
