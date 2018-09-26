//
//  AppDelegateHandler.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKEventBus

protocol AppDelegateHandler {
    var eventBus: EventBus<AppDelegate.Event> { get }

    init()
    func handle()
}
