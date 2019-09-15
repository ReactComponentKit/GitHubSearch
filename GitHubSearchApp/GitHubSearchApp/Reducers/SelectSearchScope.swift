//
//  SelectSearchScope.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import ReactComponentKit
import RxSwift

extension SearchViewModel {
    func selectSearchScope(state: SearchState, action: SearchUsersAction) -> SearchState {
        return state.copy { $0.searchScope = .user }
    }
    
    func selectSearchScope(state: SearchState, action: SearchReposAction) -> SearchState {
        return state.copy { $0.searchScope = .repo }
    }
}

