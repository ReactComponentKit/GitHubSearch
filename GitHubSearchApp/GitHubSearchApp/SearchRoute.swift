//
//  SearchRoute.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//


import BKRouter
import SafariServices

class SearchRoute: Routerable {
    static func route(scheme: String, host: String, params: [String : String], userData: [String : Any]?) -> UIViewController? {
        guard let page = params["page"] else { return nil }
        
        if page == "webView", let urlString = userData?["url"] as? String, let url = URL(string: urlString) {
            return SFSafariViewController(url: url)
        }
        
        return nil
    }
}
