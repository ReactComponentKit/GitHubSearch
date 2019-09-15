//
//  LogActionToConsole.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import ReactComponentKit

func logAction(_ action: Action) -> Action {
    print("[Action] :: \(action)")
    return action
}
