//
//  FavListVC.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 5/31/24.
//

import UIKit

class FavListVC: GFDataLoadingVC {
    
    var favs : [Follower] = []
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        configureVC()
        configureTableView()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavs()
    }
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if favs.isEmpty{
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "star")
            config.text = "No Favorites"
            config.secondaryText = "Add someone as favorite"
            contentUnavailableConfiguration = config
        }
        else{
            contentUnavailableConfiguration = nil
        }
    }
    
    func configureTableView(){
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.register(GFFavCell.self, forCellReuseIdentifier: GFFavCell.reuseID)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func configureVC(){
        view.backgroundColor = .systemBackground
        title = "Favorites"
    }
    
    func getFavs(){
        PersistanceManager.retrieveFavorites { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let favs):
                //                if favs.isEmpty{
                //                    self.showEmptyStateView(with: "No Favorites!", in: self.view)
                //                }
                //                else{
                //                    self.favs = favs
                //                    DispatchQueue.main.async {
                //                        self.tableView.reloadData()
                //                        self.view.bringSubviewToFront(self.tableView)
                //                    }
                //                }
                self.favs = favs
                setNeedsUpdateContentUnavailableConfiguration()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.bringSubviewToFront(self.tableView)
                }
                
            case .failure(let error):
                self.presentCGAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "OK")
            }
        }
        
    }
}

extension FavListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GFFavCell.reuseID, for: indexPath) as! GFFavCell
        let fav = favs[indexPath.row]
        cell.set(favorite: fav)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fav = favs[indexPath.row]
        let destVC = FollowersListVC(userName: fav.login)        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        
        PersistanceManager.updateWith(favorite: favs[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self else { return }
            guard let error else {
                favs.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                setNeedsUpdateContentUnavailableConfiguration()
                return
            }
            self.presentCGAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "OK")
        }
    }
    
    
}
