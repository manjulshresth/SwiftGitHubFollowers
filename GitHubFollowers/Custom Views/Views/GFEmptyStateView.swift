//
//  GFEmptyStateView.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 6/2/24.
//

import UIKit

class GFEmptyStateView: UIView {

    let messageLbl = GFTitleLabel(textAlignment: .center, fontSize: 28)
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(message: String){
        self.init(frame: .zero)
        messageLbl.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        addSubViews(messageLbl, imageView)
        configureMsgLabel()
        configureImgView()
    }
    
    private func configureMsgLabel(){
        messageLbl.numberOfLines = 3
        messageLbl.textColor = .secondaryLabel
        
        let labelCenterYConstant : CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? -80 : -150

        NSLayoutConstraint.activate([
            messageLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenterYConstant),
            messageLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLbl.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureImgView(){
        imageView.image = Images.emptyStateLogo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let logoBotConstant : CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 80 : 40

        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: logoBotConstant),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            imageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
        ])

    }
}
