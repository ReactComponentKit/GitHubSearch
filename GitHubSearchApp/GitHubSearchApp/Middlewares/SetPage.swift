//
//  SetPage.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import RxSwift
import BKRedux

extension SearchView {
    static func setPage(state: State, action: Action) -> Observable<State> {
        guard
            var mutableState = state as? SearchState,
            !(action is ClickItemAction)
        else {
            return .just(state)
        }
        
        switch action {
        case let act as SearchUsersAction:
            mutableState.page = act.page
        case let act as SearchReposAction:
            mutableState.page = act.page
        default:
            break
        }
        
        if mutableState.page == 1 {
            mutableState.isLoadingMore = false
            mutableState.users = []
            mutableState.repos = []
        } else {
            mutableState.isLoadingMore = true
        }
        
        return .just(mutableState)
    }
}
