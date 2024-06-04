//
//  UIView + Extension.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 6/3/24.
//

import UIKit

extension UIView{
    
    func pinToEdges(of superView: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
    }
    
    func addSubViews(_ views: UIView...){
        for view in views{
            addSubview(view)
        }
    }
}
