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
    static func reposReducer(state: State, action: Action) -> Observable<State> {
        guard
            var mutableState = state as? SearchState,
            let searchRepoAction = action as? SearchReposAction
        else {
            return .just(state)
        }
        
        if searchRepoAction.keyword.isEmpty {
            return .just(state)
        }
        
        let repos = GitHubSearchServiceProvider.searchRepos(name: searchRepoAction.keyword,
                                                            page: searchRepoAction.page,
                                                            perPage: searchRepoAction.perPage,
                                                            sort: searchRepoAction.sort).asObservable()
        
        return repos.map({ (repoList) in
            mutableState.repos += repoList
            return mutableState
        }).asObservable()
    }
}

