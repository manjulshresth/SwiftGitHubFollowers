//
//  UIHelper.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 6/2/24.
//

import UIKit

enum UIHelper{
    static func createGFFlowLayout(in view: UIView) -> UICollectionViewFlowLayout{
        let width = view.bounds.width
        let padding : CGFloat = 12
        let minSpacing : CGFloat = 10
        let availableWidth = width - (2 * padding) - (2 * minSpacing)
        let cellWidth = availableWidth/3
    
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth + 40)
        
        return flowLayout
    }

}
