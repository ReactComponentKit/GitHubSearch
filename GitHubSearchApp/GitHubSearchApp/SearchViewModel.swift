//
//  SearchViewModel.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import ReactComponentKit
import BKRedux
import RxSwift
import RxCocoa

// namespace
enum SearchView {
    
}

struct SearchState: State {
    
    enum SearchScope {
        case user
        case repo
    }
    
    enum ViewState: Equatable {
        case hello
        case loading
        case loadingIncicator
        case empty
        case list
        case error(action: Action)
        static func == (lhs: SearchState.ViewState, rhs: SearchState.ViewState) -> Bool {
            switch (lhs, rhs) {
            case (.hello, .hello):
                return true
            case (.loading, loading):
                return true
            case (.loadingIncicator, loadingIncicator):
                return true
            case (.empty, empty):
                return true
            case (.list, list):
                return true
            default:
                return false
            }
        }
    }
    
    var searchScope: SearchScope = .user
    var viewState: ViewState = .hello
    var keyword: String = ""
    var canLoadMore: Bool = false
    var isLoadingMore: Bool = false
    var page: Int = 1
    var perPage: Int = 20
    var users: [User] = []
    var userSort: GitHubSearchService.UserSort = .repositories
    var repos: [Repo] = []
    var repoSort: GitHubSearchService.RepoSort = .stars
    var sections: [DefaultSectionModel] = []
    var route: String? = nil
    var error: (Error, Action)? = nil
}

class SearchViewModel: RootViewModelType<SearchState> {
    
    struct Outputs {
        let viewState = Output<SearchState.ViewState>(value: .hello)
        let sections = Output<[DefaultSectionModel]>(value: [])
        let route = Output<String?>(value: nil)
        
        fileprivate init() {
        }
    }
    
    lazy var output: Outputs = {
        return Outputs()
    }()
    
    override init() {
        super.init()
    
        store.set(initialState: SearchState(),
                middlewares: [
                    logActionToConsole,
                    SearchView.resetSomeState,
                    SearchView.selectSearchScope,
                    SearchView.setKeyword,
                    SearchView.setPage
                ],
                reducers: [
                    SearchView.usersReducer,
                    SearchView.reposReducer,
                ],
                postwares: [
                    SearchView.makeSectionModel,
                    SearchView.selectViewState,
                    SearchView.resetFlags,
                    SearchView.makeRoute,
                    //logStateToConsole
                ])
    }
    
    override func beforeDispatch(action: Action) -> Action {
        let state = store.state
        
        output.viewState.accept(viewState(for: action))
        
        switch action {
        case let act as InputSearchKeywordAction:
            if state.searchScope == .user {
                return SearchUsersAction(keyword: act.keyword, page: 1, perPage: state.perPage, sort: state.userSort)
            } else {
                return SearchReposAction(keyword: act.keyword, page: 1, perPage: state.perPage, sort: state.repoSort)
            }
        case let act as SelectSearchScopeAction:
            if act.searchScope == .user {
                return SearchUsersAction(keyword: state.keyword, page: 1, perPage: state.perPage, sort: state.userSort)
            } else {
                return SearchReposAction(keyword: state.keyword, page: 1, perPage: state.perPage, sort: state.repoSort)
            }
        case is LoadMoreAction:
            if state.canLoadMore == false || state.isLoadingMore {
                return VoidAction()
            }
            
            if state.searchScope == .user {
                return SearchUsersAction(keyword: state.keyword, page: state.page + 1, perPage: state.perPage, sort: state.userSort)
            } else {
                return SearchReposAction(keyword: state.keyword, page: state.page + 1, perPage: state.perPage, sort: state.repoSort)
            }
        default:
            break
        }
        return action
    }
    
    override func on(newState: SearchState) {
        output.sections.accept(newState.sections)
        output.viewState.accept(newState.viewState)
        output.route.accept(newState.route)
    }
    
    override func on(error: Error, action: Action) {
        output.viewState.accept(.error(action: action))
    }
    
    func showEmptyView() {
        dispatch(action: ShowEmptyViewAction())
    }
    
    private func viewState(for action: Action) -> SearchState.ViewState {
        let state = store.state
        
        let hasContent = state.sections.isEmpty == false
        
        switch action {
        case let act as InputSearchKeywordAction:
            if act.keyword.isEmpty {
                return hasContent ? .list : .hello
            } else {
                return hasContent ? .loadingIncicator : .loading
            }
        case is SelectSearchScopeAction:
            return .loadingIncicator
        default:
            return state.viewState
        }
    }
}
