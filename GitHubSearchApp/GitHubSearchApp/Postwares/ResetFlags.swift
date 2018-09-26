//
//  ResetFlags.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKRedux
import RxSwift

extension SearchView {
    static func resetFlags(state: State, action: Action) -> Observable<State> {
        guard var mutableState = state as? SearchState else { return .just(state) }
        mutableState.isLoadingMore = false
        return .just(mutableState)
    }
}
