//
//  User.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

struct User: Codable, Hashable {
    let id: Int
    let login: String
    let htmlUrl: String
    let avatarUrl: String?
    let repoUrl: String
    
    // UserRepoInfo에서 얻는 값이다.
    var totalRepoCount: Int?
    var totalGistCount: Int?
    var followerCount: Int?
    var followingCount: Int?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case login = "login"
        case htmlUrl = "html_url"
        case avatarUrl = "avatar_url"
        case repoUrl = "repos_url"
    }
    
}
