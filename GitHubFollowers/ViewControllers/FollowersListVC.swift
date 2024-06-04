//
//  FollowersListVC.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 5/31/24.
//

import UIKit


class FollowersListVC: GFDataLoadingVC {
    
    enum Section{
        case main
    }
    
    var userName : String!
    var collectionView : UICollectionView!
    var dataSource : UICollectionViewDiffableDataSource<Section, Follower>!
    var followers : [Follower] = []
    var filteredFollowers : [Follower] = []
    var pageCount = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingMoreFollowers = false
    
    init(userName : String){
        super.init(nibName: nil, bundle: nil)
        self.userName = userName
        title = userName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        view.backgroundColor = .systemBackground
        getFollowers(username: userName, page: pageCount)
        configureDataSource()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if followers.isEmpty, !isLoadingMoreFollowers{
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "person.slash")
            config.text = "No Followers"
            config.secondaryText = "This user has no followers. Go follow"
            contentUnavailableConfiguration = config
        }
        else if isSearching && filteredFollowers.isEmpty{
            contentUnavailableConfiguration = UIContentUnavailableConfiguration.search()
        } else {
            contentUnavailableConfiguration = nil
        }
    }

    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createGFFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GFFollowerTBCell.self, forCellWithReuseIdentifier: "GFFollowerTBCell")
    }
    
    
    func getFollowers(username : String, page : Int){
        showLoadingView()
        isLoadingMoreFollowers = true

        Task{
/* Option one with specific errors*/
            do{
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: self.pageCount)
                updateUI(with: followers)
                dismissLoadingView()
                isLoadingMoreFollowers = false
            } catch {
                if let gfError = error as? GFError{
                    presentCGAlert(title: "Error", message: gfError.rawValue, buttonTitle: "OK")
                } else {
                    presentDefaultAlert()
                }
                dismissLoadingView()
            }
            
/* The option to ignore error is guard the result and ignore any error */
//            guard let followers = try? await NetworkManager.shared.getFollowers(for: username, page: self.pageCount) else {
//                dismissLoadingView()
//                presentDefaultAlert()
//                return
//            }
//            updateUI(with: followers)
//            dismissLoadingView()
        }
        
        
/* This is how completion handler used to work */
//        NetworkManager.shared.getFollowers(for: userName, page: pageCount) { [weak self] (result) in
//            guard let self = self else { return }
//            self.dismissLoadingView()
//            self.isLoadingMoreFollowers = false
//            switch result{
//            case .success(let followers):
//                self.updateUI(with: followers)
//            case .failure(let error):
//                hasMoreFollowers = false
//                self.presentCGAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "OK")
//            }
//        }
    }
    
    func updateUI(with followers: [Follower]){
        if followers.count < 100 { hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
//        if self.followers.isEmpty {
//            let message = "This user does not have any followers. Follow them 🥰"
//            DispatchQueue.main.async {
//                self.showEmptyStateView(with: message, in: self.view)
//                return
//            }
//        }
        setNeedsUpdateContentUnavailableConfiguration()
        self.updateData(on: self.followers)
    }
    
    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section,Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GFFollowerTBCell.reuseID, for: indexPath) as! GFFollowerTBCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    
    func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
    }
    
    func updateData(on followers: [Follower]){
        var snapShot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapShot.appendSections([.main])
        snapShot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, animatingDifferences: true)
        }
    }
}

extension FollowersListVC : UICollectionViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height, hasMoreFollowers{
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            pageCount += 1
            getFollowers(username: userName, page: pageCount + pageCount)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        let destVC = UserInfoVC()
        destVC.delegate = self
        destVC.userName = follower.login
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

extension FollowersListVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            isSearching = false
            updateData(on: followers)
            return
        }
        isSearching = true
        filteredFollowers = followers.filter{ $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
        setNeedsUpdateContentUnavailableConfiguration()
    }
}


extension FollowersListVC: UserInfoVCDelegate{
    func didRequestFollowers(for user: User) {
        self.userName = user.login
        title = user.login
        pageCount = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: user.login, page: pageCount)
    }
    
    
}
