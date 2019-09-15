//
//  SetPage.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import RxSwift
import ReactComponentKit

extension SearchViewModel {
    
    func setPage(state: SearchState, action: SearchUsersAction) -> SearchState {
        let mutableState = state.copy { $0.page = action.page }
        return setPage(state: mutableState)
    }
    
    func setPage(state: SearchState, action: SearchReposAction) -> SearchState {
        let mutableState = state.copy { $0.page = action.page }
        return setPage(state: mutableState)
    }
    
    func setPage(state: SearchState) -> SearchState {
        if state.page == 1 {
            return state.copy {
                $0.isLoadingMore = false
                $0.users = []
                $0.repos = []
            }
        } else {
            return state.copy {
                $0.isLoadingMore = true
            }
        }
    }
}
