//
//  LoadMoreItemModel.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import ReactComponentKit

struct LoadMoreItemModel: ItemModel {
    var id: Int {
        return "LoadMore".hashValue
    }
    
    var componentClass: UIViewComponent.Type {
        return LoadMoreComponent.self
    }
    
    var contentSize: CGSize {
        return .zero
    }
    
    init() {
    
    }
}
