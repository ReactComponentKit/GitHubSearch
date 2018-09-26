//
//  Repo.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

struct Repo: Codable, Hashable {
    let id: Int
    let name: String
    let description: String?
    let owner: User
    let htmlUrl: String
    let starCount: Int
    let forkCount: Int
    let watcherCount: Int
    let language: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case owner = "owner"
        case description = "description"
        case htmlUrl = "html_url"
        case starCount = "stargazers_count"
        case forkCount = "forks_count"
        case watcherCount = "watchers_count"
        case language = "language"
    }
}
