//
//  PersistanceManager.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 6/3/24.
//

import Foundation

enum PresistanceActionType{
    case add, remove
}

enum PersistanceManager{
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Follower, actionType: PresistanceActionType, completionHandler: @escaping (GFError?) -> Void){
        retrieveFavorites { result in
            switch result{
            case .success(var favorites):
                switch actionType{
                case .add:
                    guard !favorites.contains(favorite) else {
                        completionHandler(.alreadyFav)
                        return
                    }
                    favorites.append(favorite)
                case .remove:
                    favorites.removeAll { $0.login == favorite.login }
                }
                completionHandler(save(favorties: favorites))
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
    
    static func retrieveFavorites(completionHandler : @escaping (Result<[Follower], GFError>) -> Void){
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completionHandler(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completionHandler(.success(favorites))
        } catch {
            completionHandler(.failure(.favoriteRetrieveError))
        }
    }
    
    static func save(favorties : [Follower]) -> GFError?{
        do {
            let encoder = JSONEncoder()
            let encodedFav = try encoder.encode(favorties)
            defaults.setValue(encodedFav, forKey: Keys.favorites)
            return nil
        } catch {
            return .favoriteRetrieveError
        }
        
    }
}
