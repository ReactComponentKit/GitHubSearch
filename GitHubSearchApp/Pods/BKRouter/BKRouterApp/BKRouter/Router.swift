//
//  Router.swift
//  BKRouter
//
//  Created by burt on 2018. 9. 16..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

public protocol Routerable {
    static func route(scheme: String, host: String, params: [String: String], userData: [String: Any]?) -> UIViewController?
}

public protocol RouteSideEffect {
    static func sideEffect(vc: UIViewController, url: String, userData: [String:Any]?)
}

public class Router: NSObject {
    
    private static let instance = Router()
    private static var routerInstanceMap: [String: Router] = [:]
    
    
    // MARK: - 하나의 Nabi가 커지는 것을 막기 위해서 그룹을 만들 수 있게 한다.
    @discardableResult
    public static func register(name: String) -> Router {
        let router = Router()
        routerInstanceMap[name] = router
        return router
    }
    
    public static func unregister(name: String) {
        routerInstanceMap.removeValue(forKey: name)
    }
    
    public static func on(_ name: String) -> Router {
        guard let router = routerInstanceMap[name] else {
            return register(name: name)
        }
        return router
    }
    
    // MARK: -
    public static var shared: Router {
        return instance
    }
    
    private override init() {}
    
    private var routeSideEffectList: [RouteSideEffect.Type] = []
    private var routeMap: [String: Routerable.Type] = [:]
    
    public func add(sideEffect: RouteSideEffect.Type) {
        routeSideEffectList.append(sideEffect)
    }
    
    public func map(url: String, to convertor: Routerable.Type) {
        guard let schemeHost = schemeHost(url: url) else { return }
        routeMap[schemeHost] = convertor
    }
    
    // url에 해당하는 viewController을 받아서 직접 네비게시이션 하고자 할 때 사용한다.
    public func viewController(for url: String, userData: [String: Any]? = nil) -> UIViewController? {
        guard let vc = runRoute(for: url, with: userData) else { return nil }
        return vc
    }
    
    public func canOpen(url: String) -> Bool {
        guard let schemeHost = schemeHost(url: url) else { return false }
        return routeMap[schemeHost] != nil
    }
    
    public func push(to url: String, animated: Bool = true, userData: [String: Any]? = nil) {
        guard let topViewController = UIApplication.visibleViewController else { return }
        push(from: topViewController, to: url, animated: animated, userData: userData)
    }
    
    public func push(from: UIViewController, to url: String, animated: Bool = true, userData: [String: Any]? = nil) {
        guard let vc = viewController(for: url, userData: userData) else { return }
        routeSideEffectList.forEach { (sideEffect) in
            sideEffect.sideEffect(vc: vc, url: url, userData: userData)
        }
        
        if let navigationController = from as? UINavigationController {
            navigationController.pushViewController(vc, animated: animated)
        } else if let navigationController = from.navigationController {
            navigationController.pushViewController(vc, animated: animated)
        } else {
            let navigationController = UINavigationController(rootViewController: from)
            navigationController.pushViewController(vc, animated: animated)
        }
    }
    
    public func pop(animated: Bool = true) {
        guard let topViewController = UIApplication.visibleViewController else { return }
        pop(from: topViewController, animated: animated)
    }
    
    public func pop(from: UIViewController, animated: Bool = true) {
        if let navigationController = from as? UINavigationController {
            navigationController.popViewController(animated: animated)
        } else if let navigationController = from.navigationController {
            navigationController.popViewController(animated: animated)
        }
    }
    
    public func present(to url: String, animated: Bool = true, userData: [String: Any]? = nil, wrapNavigationController: Bool = false) {
        guard let topViewController = UIApplication.visibleViewController else { return }
        present(from: topViewController, to: url, animated: animated, userData: userData, wrapNavigationController: wrapNavigationController)
    }
    
    public func present(from: UIViewController, to url: String, animated: Bool = true, userData: [String: Any]? = nil, wrapNavigationController: Bool = false) {
        guard let vc = runRoute(for: url, with: userData) else { return }
        routeSideEffectList.forEach { (sideEffect) in
            sideEffect.sideEffect(vc: vc, url: url, userData: userData)
        }
        
        if wrapNavigationController {
            let nvc = UINavigationController(rootViewController: vc)
            from.present(nvc, animated: animated, completion: nil)
        } else {
            from.present(vc, animated: animated, completion: nil)
        }
    }
    
    public func replace(to url: String, animated: Bool = true, userData: [String: Any]? = nil, wrapNavigationController: Bool = false) {
        guard let topViewController = UIApplication.visibleViewController else { return }
        replace(from: topViewController, to: url, animated: animated, userData: userData, wrapNavigationController: wrapNavigationController)
    }
    
    public func replace(from: UIViewController, to url: String, animated: Bool = true, userData: [String: Any]? = nil, wrapNavigationController: Bool = false) {
        guard let vc = runRoute(for: url, with: userData) else { return }
        routeSideEffectList.forEach { (sideEffect) in
            sideEffect.sideEffect(vc: vc, url: url, userData: userData)
        }
        
        let viewController: UIViewController
        
        if wrapNavigationController {
            let nvc = UINavigationController(rootViewController: vc)
            viewController = nvc
        } else {
            viewController = vc
        }
        
        // @see { https://gist.github.com/nvkiet/6368d1d45c4ea3e6d9cb }
        guard let window = UIApplication.shared.keyWindow else { return }
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = viewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: nil)
        } else {
            window.rootViewController = viewController
        }
    }
    
    public func overlay(to url: String, animated: Bool = true, userData: [String: Any]? = nil) {
        guard let topViewController = UIApplication.visibleViewController else { return }
        overlay(from: topViewController, to: url, animated: animated, userData: userData)
    }
    
    public func overlay(from: UIViewController, to url: String, animated: Bool = true, userData: [String: Any]? = nil) {
        guard let vc = runRoute(for: url, with: userData) else { return }
        routeSideEffectList.forEach { (sideEffect) in
            sideEffect.sideEffect(vc: vc, url: url, userData: userData)
        }
        
        vc.modalPresentationStyle = .overFullScreen
        from.present(vc, animated: animated, completion: nil)
    }
    
    // MARK: - run router
    private func runRoute(for url: String, with userData: [String: Any]? = nil) -> UIViewController? {
        guard let schemeHost = schemeHost(url: url) else { return nil }
        guard let router = routeMap[schemeHost] else { return nil }
        guard let urlComponents = parsingURL(url: url) else { return nil }
        return router.route(scheme: urlComponents.scheme, host: urlComponents.host, params: urlComponents.params, userData: userData)
    }
    
    // MARK: - Parsing URL
    private func schemeHost(url: String) -> String? {
        guard let urlComponents = parsingURL(url: url) else { return nil }
        let scheme_host = "\(urlComponents.scheme)://\(urlComponents.host)"
        return scheme_host
    }
    private func parsingURL(url: String) -> (scheme: String, host: String, params: [String:String])? {
        var unwrapUrl = NSString(string: url).replacingOccurrences(of: "{", with: "")
        unwrapUrl = NSString(string: unwrapUrl).replacingOccurrences(of: "}", with: "")
        var urlCompoents = NSURLComponents(string: unwrapUrl)
        if urlCompoents == nil {
            if let encodedUrl = NSString(string: url).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                urlCompoents = NSURLComponents(string: encodedUrl)
            }
        }
        guard let urlComponents = urlCompoents else { return nil }
        guard let scheme = urlComponents.scheme else { return nil }
        guard let host = urlComponents.host else { return nil }
        if let queryItems = urlComponents.queryItems {
            var params: [String: String] = [:]
            queryItems.forEach ({ (urlQueryItem: URLQueryItem) in
                if var value = urlQueryItem.value {
                    if value.hasPrefix("$") {
                        value = String(value.dropFirst(1))
                    }
                    if value == "(null)" {
                        params[urlQueryItem.name] = nil
                    } else {
                        params[urlQueryItem.name] = value
                    }
                }
            })
            return (scheme: scheme, host: host, params: params)
        }
        return (scheme: scheme, host: host, params: [:])
    }
}
