//
//  SearchReposResponse.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

struct SearchReposResponse: Codable {
    let items: [Repo]?
}

