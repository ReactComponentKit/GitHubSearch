//
//  AppDelegate.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import BKEventBus

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    enum Event: EventType {
        case didFinishLaunchingWithOptions(UIApplication, UIWindow?, [UIApplication.LaunchOptionsKey: Any]?)
        case willResignActive(UIApplication, UIWindow?)
        case didEnterBackground(UIApplication, UIWindow?)
        case willEnterForeground(UIApplication, UIWindow?)
        case didBecomeActive(UIApplication, UIWindow?)
        case willTerminate(UIApplication, UIWindow?)
    }

    var window: UIWindow?
    private let eventBus = EventBus<AppDelegate.Event>()
    private let appDelegateLogHandler = AppDelegateLogHandler()
    private let appDelegateRouteHandler = AppDelegateRouteHandler()
    private let appDelegateRequiredValueChecker = AppDelegateRequiredValueChecker()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        eventBus.post(event: .didFinishLaunchingWithOptions(application, window, launchOptions))
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        eventBus.post(event: .willResignActive(application, window))
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        eventBus.post(event: .didEnterBackground(application, window))
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        eventBus.post(event: .willEnterForeground(application, window))
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        eventBus.post(event: .didBecomeActive(application, window))
    }

    func applicationWillTerminate(_ application: UIApplication) {
        eventBus.post(event: .willTerminate(application, window))
    }

}

