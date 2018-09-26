//
//  ReposReducer.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKRedux
import RxSwift

extension SearchView {
    static func reposReducer<S>(name: StateKeyPath<S>, state: StateValue?) -> (Action) -> Observable<(StateKeyPath<S>, StateValue?)> {
        return { (action) in
            guard
                let prevRepoList = state as? [Repo],
                let searchRepoAction = action as? SearchReposAction
            else {
                return .just((name, state))
            }
            
            if searchRepoAction.keyword.isEmpty {
                return .just((name, []))
            }
            
            let repos = GitHubSearchServiceProvider.searchRepos(name: searchRepoAction.keyword,
                                                                page: searchRepoAction.page,
                                                                perPage: searchRepoAction.perPage,
                                                                sort: searchRepoAction.sort).asObservable()
            
            return repos.map({ (repoList) in
                return (name, prevRepoList + repoList)
            }).asObservable()
        }
    }
}

