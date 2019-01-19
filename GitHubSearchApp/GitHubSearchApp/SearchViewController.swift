//
//  ViewController.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ReactComponentKit
import BKRouter

class SearchViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = SearchViewModel()

    private lazy var searchControllerComponent: SearchControllerComponent = {
        return SearchControllerComponent(token: viewModel.token, receiveState: false)
    }()
    
    private lazy var helloComponent: HelloViewControllerComponent = {
        return HelloViewControllerComponent(token: viewModel.token, receiveState: false)
    }()
    
    private lazy var emptyComponent: EmptyViewControllerComponent = {
        return EmptyViewControllerComponent(token: viewModel.token, receiveState: false)
    }()
    
    private lazy var errorComponent: ErrorViewControllerComponent = {
        return ErrorViewControllerComponent(token: viewModel.token, receiveState: false)
    }()
    
    private lazy var loadingComponent: LoadingViewControllerComponent = {
        return LoadingViewControllerComponent(token: viewModel.token, receiveState: false)
    }()
    
    private lazy var tableViewComponent: UITableViewComponent = {
        let component = UITableViewComponent(token: viewModel.token, receiveState: false)
        component.tableView.showsVerticalScrollIndicator = false
        return component
    }()
    
    private lazy var tableViewAdapter: UITableViewAdapter = {
        let adapter = UITableViewAdapter(tableViewComponent: tableViewComponent)
        return adapter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        setupNavigationBar()
        setupComponents()
        bindingViewModel()
        viewModel.showEmptyView()
    }
    
    private func setupComponents() {
        add(viewController: searchControllerComponent)
        view.addSubview(tableViewComponent)
        
        tableViewComponent.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableViewComponent.register(component: UserItemComponent.self)
        tableViewComponent.register(component: RepoItemComponent.self)
        tableViewComponent.register(component: LoadMoreComponent.self)
        tableViewComponent.adapter = tableViewAdapter
    }

    private func setupNavigationBar() {
        title = "GitHub Search"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        searchControllerComponent.installSearchControllerOn(navigationItem: navigationItem)
    }
    
    private func bindingViewModel() {
        viewModel.output.viewState
            .asDriver()
            .drive(onNext: handle(viewState:))
            .disposed(by: disposeBag)
        
        viewModel.output.sections
            .asDriver()
            .drive(onNext: { [weak self] (sectionModels) in
                self?.tableViewAdapter.set(sections: sectionModels, with: .fade)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.route
            .asDriver()
            .drive(onNext: { [weak self] (url) in
                guard let strongSelf = self, let url = url else { return }
                Router.shared.present(from: strongSelf, to: "myapp://scene?page=webView", animated: true, userData: ["url": url])
            })
            .disposed(by: disposeBag)
    }
    
    private func handle(viewState: SearchState.ViewState) {
        
        helloComponent.removeFromSuperViewController()
        emptyComponent.removeFromSuperViewController()
        loadingComponent.removeFromSuperViewController()
        errorComponent.removeFromSuperViewController()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        switch viewState {
        case .hello:
            self.add(viewController: helloComponent, aboveSubview: tableViewComponent)
        case .empty:
            self.add(viewController: emptyComponent, aboveSubview: tableViewComponent)
        case .loading:
            self.add(viewController: loadingComponent, aboveSubview: tableViewComponent)
        case .loadingIncicator:
            self.add(viewController: loadingComponent, aboveSubview: tableViewComponent)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        case .list:
            break
        case .error(let action):
            errorComponent.retryAction = action
            self.add(viewController: errorComponent, aboveSubview: tableViewComponent)
        }
    }
}

