//
//  EditProfileController.swift
//  twitter-clone
//
//  Created by Misael Rivera on 09/08/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EditProfileCell"

class EditProfileController: UITableViewController {
    
    //MARK: - Properties
    private let user: User
    private lazy var headerView = EditProfileHeader(user: user)
    private let imagePicker = UIImagePickerController()
    
    private var selectImage: UIImage? {
        didSet {
            headerView.profileImageView.image = selectImage
        }
    }
    
    //MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        configureNavigationBar()
        configureTableView()
    }
    
    //MARK: - Selectors
    @objc func handleCancel() {
        
    }
    
    @objc func handleDone() {
        
    }
    
    //MARK: - API
    
    //MARK: - Helpers
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        navigationController?.title = "Edit profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        tableView.tableFooterView = UIView()
        
        headerView.delegate = self
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
        return cell
    }
}

extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return 0}
        return option == .bio ? 100 : 48
    }
}

//MARK: - EditProfileHeaderProtocol
extension EditProfileController: EditProfileHeaderProtocol {
    
    func didTapChangeProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
}

extension EditProfileController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.selectImage = image
        
        dismiss(animated: true, completion: nil)
    }
}

