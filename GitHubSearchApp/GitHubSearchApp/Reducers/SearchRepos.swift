//
//  ReposReducer.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import ReactComponentKit
import RxSwift

extension SearchViewModel {
    func searchReposReducer(action: SearchReposAction) -> Observable<SearchState> {
        if action.keyword.isEmpty {
            return withState { state in
                return .just(state)
            }
        }
        
        let repos = GitHubSearchServiceProvider.searchRepos(name: action.keyword,
                                                            page: action.page,
                                                            perPage: action.perPage,
                                                            sort: action.sort).asObservable()
        
        return repos.map({ [weak self] (repoList) in
            guard let strongSelf = self else { return SearchState() }
            return strongSelf.withState { state in
                state.copy { $0.repos += repoList }
            }
        }).asObservable()
    }
}

