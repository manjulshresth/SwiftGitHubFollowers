//
//  GFTabBarController.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 6/3/24.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        
        //        let tabBarApperance = UITabBarAppearance()
        //        tabBarApperance.configureWithOpaqueBackground()
        //        UITabBar.appearance().standardAppearance = tabBarApperance
        //        UITabBar.appearance().scrollEdgeAppearance = tabBarApperance

        self.viewControllers = [createSearchNC(), createFavListNC()]

        // Do any additional setup after loading the view.
    }
    
    func createSearchNC() -> UINavigationController{
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createFavListNC() -> UINavigationController{
        let favListVC = FavListVC()
        favListVC.title = "Favorites"
        favListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favListVC)
    }

}
