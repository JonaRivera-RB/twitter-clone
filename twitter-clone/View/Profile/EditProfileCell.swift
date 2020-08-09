//
//  EditProfileCell.swift
//  twitter-clone
//
//  Created by Misael Rivera on 09/08/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit

protocol EditProfileCellDelegate: class {
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {
    
    //MARK: - Properties
    weak var delegate: EditProfileCellDelegate?
    
    var viewModel: EditProfileViewModel? {
        didSet { configure() }
    }
    
    //MARK: - Lyfecicle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemPurple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
}
