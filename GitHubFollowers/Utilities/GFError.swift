//
//  GFError.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 5/31/24.
//

import Foundation

enum GFError : String, Error {
    case invalidUsername = "This username created an invalid request. Please enter valid username"
    case invalidInternetConnectioin = "Unable to complete request. Please check internet connection"
    case invalidResposne = "Invalid response from server. Please try again"
    case invalidData = "The data received from server was invalid. Please try again"
    case favoriteRetrieveError = "Thre was error trying to retrieve favrite"
    case alreadyFav = "This user is already favorite"
}
