//
//  GFFollowerTBSwiftUI.swift
//  GitHubFollowers
//
//  Created by Manjul Shrestha on 6/3/24.
//

import SwiftUI

struct GFFollowerTBSwiftUI: View {
    var follower : Follower
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: follower.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(.avatarPlaceholder)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .clipShape(Circle())
            Text(follower.login)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
    }
}

#Preview {
    GFFollowerTBSwiftUI(follower: Follower(login: "Manjul", avatarUrl: ""))
}
