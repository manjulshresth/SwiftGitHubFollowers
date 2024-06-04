//
//  GFAlertVC.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 5/31/24.
//

import UIKit

class GFAlertVC: UIViewController {
    
    let containerView = GFContainerView()
    let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = GFBodyLabel(textAlignment: .center)
    let alertBtn = GFButton(color: .systemPink, title: "OK", systemImageName: "checkmark.circle")

    var alertTitle : String?
    var message : String?
    var buttonTitle : String?
    let padding : CGFloat = 20

    
    init(title: String, message: String, buttonTitle: String){
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle

        configureContainerView()
        configureTitleLabel()
        configureAlertButton()
        configureMessageLabel()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubViews(containerView,titleLabel,messageLabel, alertBtn)
    }
    
    
    private func configureContainerView() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    private func configureTitleLabel() {
        titleLabel.text = self.alertTitle
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)

        ])
    }

    
    
    private func configureAlertButton() {
        alertBtn.setTitle(self.buttonTitle, for: .normal)
        alertBtn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            alertBtn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            alertBtn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            alertBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            alertBtn.heightAnchor.constraint(equalToConstant: 44)

        ])
    }
    
    private func configureMessageLabel() {
        messageLabel.text = message
        messageLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: alertBtn.topAnchor, constant: -12)
        ])
    }


    @objc func dismissView(){
        dismiss(animated: true)
    }


}
