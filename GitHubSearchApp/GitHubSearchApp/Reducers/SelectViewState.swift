//
//  ViewStatePostware.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import ReactComponentKit
import RxSwift

extension SearchViewModel {
    func selectViewState(state: SearchState, action: Action) -> SearchState {
        if state.error != nil {
            return state.copy { $0.viewState = .error(action: action) }
        } else if state.sections.isEmpty {
            return state.copy { $0.viewState = state.keyword.isEmpty ? .hello : .empty }
        } else if let first = state.sections.first, first.items.isEmpty {
            return state.copy { $0.viewState =  state.keyword.isEmpty ? .hello : .empty }
        } else {
            return state.copy { $0.viewState = .list }
        }
    }
}
