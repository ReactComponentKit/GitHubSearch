//
//  SetKeyword.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import RxSwift
import ReactComponentKit

extension SearchViewModel {
    
    func setKeyword(state: SearchState, action: SearchUsersAction) -> SearchState {
        return state.copy { $0.keyword = action.keyword }
    }
    
    func setKeyword(state: SearchState, action: SearchReposAction) -> SearchState {
        return state.copy { $0.keyword = action.keyword }
    }
    
}
