//
//  UsersReducer.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKRedux
import RxSwift

extension SearchView {
    static func usersReducer(state: State, action: Action) -> Observable<State> {
        guard
            var mutableState = state as? SearchState,
            let searchUserAction = action as? SearchUsersAction
        else {
            return .just(state)
        }
        
        if searchUserAction.keyword.isEmpty {
            return .just(state)
        }
    
        let users = GitHubSearchServiceProvider.searchUsers(name: searchUserAction.keyword,
                                                            page: searchUserAction.page,
                                                            perPage: searchUserAction.perPage,
                                                            sort: searchUserAction.sort).asObservable()
        
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
            .map({ (userList) in
                mutableState.users += userList
                return mutableState
            }).asObservable()
    }
}
