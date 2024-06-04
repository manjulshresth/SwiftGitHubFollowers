//
//  Date + Extension.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 6/3/24.
//

import Foundation

extension Date{
//    func convertToMonthYearFormat() -> String{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM yyyy"
//        return dateFormatter.string(from: self)
//    }
    
    func convertToMonthYearFormat() -> String{
        return formatted(.dateTime.month().year())
    }

}
