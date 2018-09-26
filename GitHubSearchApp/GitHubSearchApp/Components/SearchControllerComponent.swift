//
//  SearchControllerComponent.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import ReactComponentKit
import RxSwift
import RxCocoa

class SearchControllerComponent: UIViewControllerComponent {
    
    private let disposeBag = DisposeBag()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.scopeButtonTitles = ["User", "Repo"]
        controller.searchBar.showsScopeBar = true
        controller.searchBar.autocorrectionType = .no
        controller.searchBar.autocapitalizationType = .none
        controller.searchBar.keyboardType = .webSearch
        return controller
    }()
    
    func installSearchControllerOn(navigationItem: UINavigationItem) {
        navigationItem.searchController = searchController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController
            .searchBar
            .rx
            .text
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map {
                InputSearchKeywordAction(keyword: $0 ?? "")
            }
            .bind(onNext: dispatch(action:))
            .disposed(by: disposeBag)
                
        searchController
            .searchBar
            .rx
            .textDidEndEditing
            .map { [weak self] in
                InputSearchKeywordAction(keyword: self?.searchController.searchBar.text ?? "")
            }
            .bind(onNext: dispatch(action:))
            .disposed(by: disposeBag)
        
        searchController
            .searchBar
            .rx
            .selectedScopeButtonIndex
            .map { (index) in
                let scope: SearchState.SearchScope = index == 0 ? .user : .repo
                return SelectSearchScopeAction(searchScope: scope)
            }
            .bind(onNext: dispatch(action:))
            .disposed(by: disposeBag)
    }
}


