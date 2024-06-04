//
//  GFAvatarImageView.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 5/31/24.
//

import UIKit

class GFAvatarImageView: UIImageView {
//    let cache = NetworkManager.shared.cache
    let placerholderImg = Images.placeholder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placerholderImg
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from urlString: String){
//        NetworkManager.shared.getThumbImage(from: urlString, completionHandler: { [weak self] image in
//            guard let self = self else { return }
//            if let img = image{
//                DispatchQueue.main.async {
//                    self.image = img
//                }
//            }
//        })
        
        Task{
            image = await NetworkManager.shared.getThumbImage(from: urlString) ?? placerholderImg
        }
    }
}
