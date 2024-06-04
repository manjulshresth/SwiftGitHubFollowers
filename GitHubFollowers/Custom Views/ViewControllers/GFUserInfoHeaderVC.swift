//
//  GFUserInfoHeaderVC.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 6/3/24.
//

import UIKit

class GFUserInfoHeaderVC: UIViewController {
    
    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLbl = GFTitleLabel(textAlignment: .left, fontSize: 34)
    let nameLbl = GFSecondaryTitleLabel(fontSize: 18)
    let locationImgView = UIImageView()
    let locationLbl = GFSecondaryTitleLabel(fontSize: 18)
    let bioLbl = GFBodyLabel(textAlignment: .left)
    
    var user : User!
    
    init(user: User!) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews(avatarImageView,usernameLbl,nameLbl,locationImgView,locationLbl,bioLbl)
        layoutUI()
        configureUIElements()
    }
    
    func configureUIElements(){
        avatarImageView.downloadImage(from: user.avatarUrl)
        usernameLbl.text = user.login
        nameLbl.text = user.name ?? ""
        locationImgView.image = SFSymbols.location
        locationImgView.tintColor = .secondaryLabel
        locationLbl.text = user.location ?? "No location"
        bioLbl.text = user.bio ?? ""
        bioLbl.numberOfLines = 3

    }
    
    func layoutUI(){
        let padding : CGFloat = 20
        let textImgPadding : CGFloat = 12
        locationImgView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            usernameLbl.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLbl.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImgPadding),
            usernameLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usernameLbl.heightAnchor.constraint(equalToConstant: 30),
            
            nameLbl.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            nameLbl.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImgPadding),
            nameLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLbl.heightAnchor.constraint(equalToConstant: 20),

            locationImgView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImgView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImgPadding),
            locationImgView.widthAnchor.constraint(equalToConstant: 20),
            locationImgView.heightAnchor.constraint(equalToConstant: 20),

            locationLbl.centerYAnchor.constraint(equalTo: locationImgView.centerYAnchor),
            locationLbl.leadingAnchor.constraint(equalTo: locationImgView.trailingAnchor, constant: 5),
            locationLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationLbl.heightAnchor.constraint(equalToConstant: 20),

            bioLbl.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImgPadding),
            bioLbl.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bioLbl.heightAnchor.constraint(equalToConstant: 90),

        ])
    }

}
