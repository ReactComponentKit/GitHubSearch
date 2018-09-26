//
//  GitHubService.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import Moya

enum GitHubSearchService {
    
    enum RepoSort: String {
        case stars
        case forks
        case updated
    }
    
    enum UserSort: String {
        case followers
        case repositories
        case joined
    }
    
    case repos(q: String, page: Int, perPage: Int, sort: RepoSort)
    case users(q: String, page: Int, perPage: Int, sort: UserSort)
    case userRepoInfo(userName: String)
}


extension GitHubSearchService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .repos:
            return "/search/repositories"
        case .users:
            return "/search/users"
        case .userRepoInfo(let userName):
            return "/users/\(userName)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .repos, .users, .userRepoInfo:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .repos, .users, .userRepoInfo:
            return "{}".data(using: String.Encoding.utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .repos(let q, let page, let perPage, let sort):
            return .requestParameters(parameters: ["q": q, "page": page, "per_page": perPage, "sort": sort.rawValue, "client_id": GitHubAPIKey.client_id, "client_secret": GitHubAPIKey.client_secret], encoding: URLEncoding.default)
        case .users(let q, let page, let perPage, let sort):
            return .requestParameters(parameters: ["q": q, "page": page, "per_page": perPage, "sort": sort.rawValue, "client_id": GitHubAPIKey.client_id, "client_secret": GitHubAPIKey.client_secret], encoding: URLEncoding.default)
        case .userRepoInfo:
            return .requestParameters(parameters: ["client_id": GitHubAPIKey.client_id, "client_secret": GitHubAPIKey.client_secret], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
