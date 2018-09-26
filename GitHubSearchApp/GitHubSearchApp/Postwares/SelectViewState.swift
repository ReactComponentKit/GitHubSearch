//
//  ViewStatePostware.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKRedux
import RxSwift

extension SearchView {
    static func selectViewState(state: State, action: Action) -> Observable<State> {
        guard let searchState = state as? SearchState else { return .just(state) }
        
        var mutableState = searchState
        
        if searchState.error != nil {
            mutableState.viewState = .error(action: action)
        } else if searchState.sections.isEmpty {
            mutableState.viewState = searchState.keyword.isEmpty ? .hello : .empty
        } else if let first = searchState.sections.first, first.items.isEmpty {
            mutableState.viewState = searchState.keyword.isEmpty ? .hello : .empty
        } else {
            mutableState.viewState = .list
        }
        
        return .just(mutableState)
    }
}
