//
//  SearchVC.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 5/31/24.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoImageView = UIImageView()
    let usernameTF = GFTextField()
    let followerBtn = GFButton(color: .systemGreen, title: "Get Followers", systemImageName: "person.3")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubViews(logoImageView, followerBtn,usernameTF)

        configureLogoImageView()
        configureTextField()
        configurefollowersBtn()
        tapToDismiss()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTF.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func tapToDismiss(){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    
    private func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        
        let topConstraintConstant : CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
                
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureTextField() {
        usernameTF.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTF.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTF.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            usernameTF.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    
    private func configurefollowersBtn() {
        followerBtn.addTarget(self, action: #selector(pushToFollowersVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            followerBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            followerBtn.heightAnchor.constraint(equalToConstant: 50),
            followerBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            followerBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
        ])
    }
    
    @objc func pushToFollowersVC( ){
        guard !usernameTF.text!.isEmpty else {
            presentCGAlertOnMainThread(title: "Empty Username", message: "Enter user name. We need a name. 😊", buttonTitle: "OK")
            return
        }
        let followerListVC = FollowersListVC(userName: usernameTF.text!)
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    


}

extension SearchVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        pushToFollowersVC()
        return true
    }
}


#Preview {
    return SearchVC()
}
