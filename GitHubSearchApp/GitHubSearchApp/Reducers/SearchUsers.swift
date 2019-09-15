//
//  UsersReducer.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import ReactComponentKit
import RxSwift

extension SearchViewModel {
    func searchUsersReducer(action: SearchUsersAction) -> Observable<SearchState> {
        if action.keyword.isEmpty {
            return withState { state in
                return .just(state)
            }
        }
        
        let users = GitHubSearchServiceProvider.searchUsers(name: action.keyword,
                                                            page: action.page,
                                                            perPage: action.perPage,
                                                            sort: action.sort).asObservable()
        
        return users.flatMap({ (userList: [User]) -> Observable<User> in
            Observable.from(userList)
                .flatMap({ (user: User) -> Observable<User> in
                    GitHubSearchServiceProvider.fetchUserRepoInfo(userName: user.login)
                        .asObservable()
                        .map({ (repoInfo) -> User in
                            var mutableUser = user
                            mutableUser.name = repoInfo.name
                            mutableUser.totalGistCount = repoInfo.publicGistCount
                            mutableUser.totalRepoCount = repoInfo.publicRepoCount
                            mutableUser.followerCount = repoInfo.followerCount
                            mutableUser.followingCount = repoInfo.followingCount
                            return mutableUser
                        })
                })
                .asObservable()
            })
            .toArray()
            .map({ [weak self] (userList) in
                guard let strongSelf = self else { return SearchState() }
                return strongSelf.withState { state in
                    state.copy { $0.users += userList }
                }
            }).asObservable()
    }
}
