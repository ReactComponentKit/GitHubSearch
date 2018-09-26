//
//  AppDelegateRequiredValueChecker.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKEventBus

class AppDelegateRequiredValueChecker: AppDelegateHandler {
    var eventBus = EventBus<AppDelegate.Event>()
    
    required init() {
        handle()
    }
    
    func handle() {
        eventBus.on { (event: AppDelegate.Event) in
            switch event {
            case .didFinishLaunchingWithOptions:
                assert(GitHubAPIKey.client_id.isEmpty == false, "You should set a client_id from GitHub.com to run this example")
                assert(GitHubAPIKey.client_secret.isEmpty == false, "You should set a client_secret from GitHub.com to run this example")
            default:
                break
            }
        }
    }
    
}

