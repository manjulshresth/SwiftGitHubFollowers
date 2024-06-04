//
//  UserInfoVC.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 6/2/24.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject{
    func didRequestFollowers(for user: User)
}


class UserInfoVC: GFDataLoadingVC {
    
    var userName : String!
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo =  UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var userShown : User?
    
    //Scroll View
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    weak var delegate : UserInfoVCDelegate?
    
    var itemViews : [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        getUserInfo()
        configureScrollView()
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnTapped))
        navigationItem.rightBarButtonItem = doneBtn
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnTapped))
        navigationItem.leftBarButtonItem = addBtn

    }
    
    func configureScrollView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)        
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
        
    }
    
    func getUserInfo(){
//        NetworkManager.shared.getUserInfo(for: userName) { [weak self] result in
//            guard let self = self else { return }
//            switch result{
//            case .success(let user):
//                DispatchQueue.main.async {
//                    self.configureUIElements(with: user)
//                }
//            case .failure(let error):
//                presentCGAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
//            }
//        }
        Task{
            do{
                let user = try await NetworkManager.shared.getUserInfo(for: userName)
                userShown = user
                configureUIElements(with: user)
            } catch {
                if let gfError = error as? GFError{
                    presentCGAlert(title: "Error", message: gfError.rawValue, buttonTitle: "OK")
                } else {
                    presentDefaultAlert()
                }
                dismissLoadingView()
            }
        }

    }
    
    func configureUIElements(with user: User){
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: GFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
        self.add(childVC: GFFollowerItemVC(user: user, delegate: self), to: self.itemViewTwo)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
    }
    
    func layoutUI(){
        let padding : CGFloat = 20
        itemViews = [headerView,itemViewOne, itemViewTwo, dateLabel]
        for itemView in itemViews{
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: padding),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: 140),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: 140),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])

    }
    
    func add(childVC : UIViewController, to containerView: UIView){
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    @objc func doneBtnTapped(){
        dismiss(animated: true)
    }
    
    @objc func addBtnTapped(){
        guard let userShown else { return }
        self.addUsersToFav(user: userShown)
    }
    
    func addUsersToFav(user : User){
        let fav = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistanceManager.updateWith(favorite: fav, actionType: .add) { [weak self] error in
            guard let self else { return }
            guard let error else {
                self.presentCGAlertOnMainThread(title: "Success", message: "You added the user to favorites", buttonTitle: "OK")
                return
            }
            self.presentCGAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "OK")
        }

    }

}

extension UserInfoVC: GFRepoItemVCDelegate{
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentCGAlert(title: "Invalid URl", message: "URL attached to user is invalid", buttonTitle: "OK")
            return
        }
        presentSafariVC(with: url)
    }
}


extension UserInfoVC: GFFollowerItemVCDelegate{    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentCGAlert(title: "No followers", message: "This user has no followers", buttonTitle: "OK")
            return
        }
        delegate?.didRequestFollowers(for: user)
        dismiss(animated: true)
    }
}
