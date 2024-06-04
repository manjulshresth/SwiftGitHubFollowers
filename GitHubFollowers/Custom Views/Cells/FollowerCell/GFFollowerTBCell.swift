//
//  GFFollowerTBCell.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 5/31/24.
//

import UIKit
import SwiftUI

class GFFollowerTBCell: UICollectionViewCell {
    static let reuseID = "GFFollowerTBCell"
    
//    let avatarImageView = GFAvatarImageView(frame: .zero)
//    let userNameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(follower: Follower){
//        if #available(iOS 16.0, *){
            contentConfiguration = UIHostingConfiguration { GFFollowerTBSwiftUI(follower: follower) }
//        }
//        else{
//            userNameLabel.text = follower.login
//            avatarImageView.downloadImage(from: follower.avatarUrl)
//        }
    }
    
//    private func configure(){
//        addSubViews(avatarImageView,userNameLabel)
//        let padding: CGFloat = 8
//        
//        NSLayoutConstraint.activate([
//            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
//            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
//            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
//            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
//        
//            userNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
//            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
//            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
//            userNameLabel.heightAnchor.constraint(equalToConstant: 20)
//        ])
//
//    }
}
