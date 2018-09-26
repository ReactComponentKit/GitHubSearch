//
//  AppDelegateLogHandler.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKEventBus

class AppDelegateLogHandler: AppDelegateHandler {
    
    var eventBus = EventBus<AppDelegate.Event>()
    
    required init() {
        handle()
    }
    
    func handle() {
        eventBus.on { (event: AppDelegate.Event) in
            switch event {
            case let .didFinishLaunchingWithOptions(_, _, launchOptions):
                if let launchOptions = launchOptions {
                    print("Application did finish launching with options: \(launchOptions)")
                } else {
                    print("Application did finish launching without options")
                }
            case .didBecomeActive(_, _):
                print("Application did become activate")
            case .didEnterBackground(_, _):
                print("Application did enter background")
            case .willEnterForeground(_, _):
                print("Application will enter foreground")
            case .willResignActive(_, _):
                print("Application will resign activate")
            case .willTerminate(_, _):
                print("Application will terminate")
            }
        }
    }
    
    
}
