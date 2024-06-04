//
//  User.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 5/31/24.
//

import Foundation

struct User: Codable{
    let login : String
    let avatarUrl : String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl : String
    let following : Int
    let followers: Int
    let createdAt : Date
}
