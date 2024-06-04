//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 5/31/24.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "https://api.github.com/users/"
    let cache = NSCache<NSString,UIImage>()
    let decoder = JSONDecoder()

    private init(){
        decoder.keyDecodingStrategy = . convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
/* This is completion handler example */
//    func getFollowers(for userName:String, page: Int, completionHandler : @escaping (Result<[Follower], GFError>) -> Void) {
//        let endPoint = baseUrl + "\(userName)/followers?per_page=100&page=\(page)"
//        guard let url = URL(string: endPoint) else {
//            completionHandler(.failure(.invalidUsername))
//            return
//        }
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let _ = error {
//                completionHandler(.failure(.invalidInternetConnectioin))
//                return
//            }
//            guard let respones = response as? HTTPURLResponse, respones.statusCode == 200 else {
//                completionHandler(.failure(.invalidResposne))
//                return
//            }
//            guard let data = data else {
//                completionHandler(.failure(.invalidData))
//                return
//            }
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                decoder.dateDecodingStrategy = .iso8601
//                let followers = try decoder.decode([Follower].self, from: data)
//                completionHandler(.success(followers))
//            } catch {
//                completionHandler(.failure(.invalidData))
//            }
//        }
//        task.resume()
//    }
    
//    func getUserInfo(for userName:String, completionHandler : @escaping (Result<User, GFError>) -> Void) {
//        let endPoint = baseUrl + "\(userName)"
//        guard let url = URL(string: endPoint) else {
//            completionHandler(.failure(.invalidUsername))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let _ = error {
//                completionHandler(.failure(.invalidInternetConnectioin))
//                return
//            }
//            guard let respones = response as? HTTPURLResponse, respones.statusCode == 200 else {
//                completionHandler(.failure(.invalidResposne))
//                return
//            }
//            guard let data = data else {
//                completionHandler(.failure(.invalidData))
//                return
//            }
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                decoder.dateDecodingStrategy = .iso8601
//                let user = try decoder.decode(User.self, from: data)
//                completionHandler(.success(user))
//            } catch {
//                completionHandler(.failure(.invalidData))
//            }
//        }
//        task.resume()
//    }

//    func getThumbImage(from urlString: String, completionHandler : @escaping ((UIImage?) -> Void)){
//        let cacheKey = NSString(string: urlString)
//        if let image = cache.object(forKey: cacheKey){
//            completionHandler(image)
//            return
//        }
//        guard let url = URL(string: urlString) else {
//            completionHandler(nil)
//            return
//        }
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            guard let self = self,
//                    error == nil,
//                  let respose = response as? HTTPURLResponse, respose.statusCode == 200,
//                  let data = data,
//                  let image = UIImage(data: data) else {
//                completionHandler(nil)
//                return
//            }
//            self.cache.setObject(image, forKey: cacheKey)
//            return completionHandler(image)
//        }
//        task.resume()
//    }

    func getFollowers(for userName:String, page: Int) async throws -> [Follower] {
        let endPoint = baseUrl + "\(userName)/followers?per_page=100&page=\(page)"
        guard let url = URL(string: endPoint) else { throw GFError.invalidUsername }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let respones = response as? HTTPURLResponse, respones.statusCode == 200 else { throw GFError.invalidResposne }
        
        do {
            return try decoder.decode([Follower].self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }

    func getUserInfo(for userName:String) async throws -> User {
        let endPoint = baseUrl + "\(userName)"
        guard let url = URL(string: endPoint) else { throw GFError.invalidUsername }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let respones = response as? HTTPURLResponse, respones.statusCode == 200 else { throw GFError.invalidResposne }
        
        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }

    func getThumbImage(from urlString: String) async -> UIImage?{
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey){ return image }
        guard let url = URL(string: urlString) else { return nil }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data : data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
    
}
