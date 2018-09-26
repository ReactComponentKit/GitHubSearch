//
//  LoadMoreComponent.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import ReactComponentKit

class LoadMoreComponent: UIViewComponent {
    
    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        return view
    }()
    
    override var contentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 50)
    }
    
    override func setupView() {
        addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        indicator.startAnimating()
    }
    
    override func configure<Item>(item: Item) {
        indicator.startAnimating()
        dispatch(action: LoadMoreAction())
    }
}

