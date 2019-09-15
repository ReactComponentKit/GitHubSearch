//
//  MakeRoute.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import ReactComponentKit
import RxSwift

extension SearchViewModel {
    func handleClickItem(state: SearchState, action: ClickItemAction) -> SearchState {
        return state.copy { $0.route = action.htmlUrl }
    }
}
