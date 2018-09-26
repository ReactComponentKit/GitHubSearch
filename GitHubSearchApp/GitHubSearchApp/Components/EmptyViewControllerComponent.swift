//
//  EmptyViewController.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import ReactComponentKit

class EmptyViewControllerComponent: UIViewControllerComponent {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "ironcat")
        return view
    }()
    
    private lazy var label: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.boldSystemFont(ofSize: 19)
        view.textColor = UIColor.black
        view.text = "Oops!!! There is no search result!"
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(label)
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
}
