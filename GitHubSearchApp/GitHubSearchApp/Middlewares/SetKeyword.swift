//
//  SetKeyword.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import RxSwift
import BKRedux

extension SearchView {
    static func setKeyword(state: State, action: Action) -> Observable<State> {
        guard var mutableState = state as? SearchState else { return .just(state) }
    
        switch action {
        case let act as SearchUsersAction:
            mutableState.keyword = act.keyword
        case let act as SearchReposAction:
            mutableState.keyword = act.keyword
        default:
            break
        }
        
        return .just(mutableState)
    }
}
