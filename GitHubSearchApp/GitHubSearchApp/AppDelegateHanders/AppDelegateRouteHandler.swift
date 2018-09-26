//
//  AppDelegateRouteHandler.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKEventBus
import BKRouter

class AppDelegateRouteHandler: AppDelegateHandler {
    var eventBus = EventBus<AppDelegate.Event>()
    
    required init() {
        handle()
    }
    
    func handle() {
        eventBus.on { (event: AppDelegate.Event) in
            switch event {
            case .didFinishLaunchingWithOptions:
                Router.shared.map(url: "myapp://scene?page=$value", to: SearchRoute.self)
            default:
                break
            }
        }
    }
    
}
