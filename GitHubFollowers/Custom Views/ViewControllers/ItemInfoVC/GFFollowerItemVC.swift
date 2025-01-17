//
//  GFFollowerItemVC.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 6/3/24.
//

import UIKit


protocol GFFollowerItemVCDelegate : AnyObject{
    func didTapGetFollowers(for user: User)
}

class GFFollowerItemVC: GFItemInfoVC{
    
    weak var delegate : GFFollowerItemVCDelegate?
    
    init(user: User, delegate : GFFollowerItemVCDelegate){
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following    , with: user.following)
        actionBtn.set(color: .systemGreen, title: "Get Followers", systemImageName: "person.3")
    }
    
    override func actionButtonTapped() {
        delegate?.didTapGetFollowers(for: user)
    }

}
