//
//  LogStateToConsole.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKRedux
import RxSwift

func logStateToConsole(state: State, action: Action) -> Observable<State> {
    guard let searchState = state as? SearchState else { return .just(state) }
    print("[### State BEGIN ###]")
    print("\(searchState.viewState)")
    print("[### State END ###]")
    return .just(state)
}
