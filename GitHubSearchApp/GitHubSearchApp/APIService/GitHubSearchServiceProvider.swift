//
//  GitHubSearchServiceProvider.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa

enum GitHubSearchServiceProvider {
    
    static private let provider = MoyaProvider<GitHubSearchService>()
    
    static func searchUsers(name: String, page: Int, perPage: Int = 20, sort: GitHubSearchService.UserSort = .repositories) -> Single<[User]> {
        return Single.create(subscribe: { (single) -> Disposable in
            
            let cancellable = provider.request(.users(q: name, page: page, perPage: perPage, sort: sort)) { (result) in
                switch result {
                case .success(let response):
                    let users = try? response.map(SearchUsersResponse.self)
                    single(.success(users?.items ?? []))
                case .failure(let error):
                    single(.error(error))
                }
            }
            
            return Disposables.create {
                if cancellable.isCancelled == false {
                    cancellable.cancel()
                }
            }
        })
    }
    
    static func searchRepos(name: String, page: Int, perPage: Int = 20, sort: GitHubSearchService.RepoSort = .stars) -> Single<[Repo]> {
        return Single.create(subscribe: { (single) -> Disposable in
            
            let cancellable = provider.request(.repos(q: name, page: page, perPage: perPage, sort: sort)) { (result) in
                switch result {
                case .success(let response):
                    let repos = try? response.map(SearchReposResponse.self)
                    single(.success(repos?.items ?? []))
                case .failure(let error):
                    single(.error(error))
                }
            }
            
            return Disposables.create {
                if cancellable.isCancelled == false {
                    cancellable.cancel()
                }
            }
        })
    }
    
    static func fetchUserRepoInfo(userName: String) -> Single<UserRepoInfo> {
        return Single.create(subscribe: { (single) -> Disposable in
            
            let cancellable = provider.request(.userRepoInfo(userName: userName)) { (result) in
                switch result {
                case .success(let response):
                    let userRepoInfo = try? response.map(UserRepoInfo.self)
                    single(.success(userRepoInfo ?? UserRepoInfo()))
                case .failure(let error):
                    single(.error(error))
                }
            }
            
            return Disposables.create {
                if cancellable.isCancelled == false {
                    cancellable.cancel()
                }
            }
        })
    }
    
}
