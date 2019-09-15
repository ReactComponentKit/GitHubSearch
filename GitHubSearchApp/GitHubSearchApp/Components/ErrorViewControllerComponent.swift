//
//  ErrorViewControllerComponent.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import ReactComponentKit
import RxSwift
import RxCocoa

class ErrorViewControllerComponent: UIViewControllerComponent {

    private let disposeBag = DisposeBag()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(named: "ironcat")
        return view
    }()
    
    private lazy var label: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.boldSystemFont(ofSize: 19)
        view.textColor = UIColor.black
        view.text = "Oops!!!"
        return view
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Retry", for: [])
        return button
    }()
    
    public var retryAction: Action? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(retryButton)
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        retryButton.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        if let retryAction = retryAction {
            retryButton.rx.tap.map { retryAction }.bind(onNext: dispatch(action:)).disposed(by: disposeBag)
        }
    }
}
