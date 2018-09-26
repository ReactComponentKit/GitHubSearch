//
//  UserItem.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import ReactComponentKit

struct UserItemModel: ItemModel {
    var id: Int {
        return user.id
    }
    
    var componentClass: UIViewComponent.Type {
        return UserItemComponent.self
    }
    
    var contentSize: CGSize {
        return .zero
    }
    
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
}
