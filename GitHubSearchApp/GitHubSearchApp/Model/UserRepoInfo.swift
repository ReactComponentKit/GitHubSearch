//
//  UserRepoInfo.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

struct UserRepoInfo: Codable {
    var publicRepoCount: Int = 0
    var publicGistCount: Int = 0
    var followerCount: Int = 0
    var followingCount: Int = 0
    var name: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case publicRepoCount = "public_repos"
        case publicGistCount = "public_gists"
        case followerCount = "followers"
        case followingCount = "following"
        case name = "name"
    }
}
