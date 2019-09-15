//
//  SearchUerAction.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import ReactComponentKit

struct SearchUsersAction: Action {
    let keyword: String
    let page: Int
    let perPage: Int
    let sort: GitHubSearchService.UserSort
}
