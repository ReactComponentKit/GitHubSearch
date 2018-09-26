//
//  ShowEmptyViewAction.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKRedux

struct ShowEmptyViewAction: Action {
    let viewState: SearchState.ViewState = .empty
}
