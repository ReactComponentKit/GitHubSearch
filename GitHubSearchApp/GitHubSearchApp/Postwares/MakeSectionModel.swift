//
//  MakeSectionModel.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKRedux
import RxSwift
import ReactComponentKit

extension SearchView {
    static func makeSectionModel(state: State, action: Action) -> Observable<State> {
        guard var mutableState = state as? SearchState else { return .just(state) }
        
        return Single.create(subscribe: { (single) -> Disposable in
            let sectionModel: SectionModel
            switch mutableState.searchScope {
            case .user:
                sectionModel = makeUserSectionModel(users: mutableState.users)
                mutableState.canLoadMore = (mutableState.users.count > 0 && mutableState.users.count % mutableState.perPage == 0)
            case .repo:
                sectionModel = makeRepoSectionModel(repos: mutableState.repos)
                mutableState.canLoadMore = (mutableState.repos.count > 0 && mutableState.repos.count % mutableState.perPage == 0)
            }
            
            if mutableState.canLoadMore {
                let loadMoreSectionModel = DefaultSectionModel(items: [LoadMoreItemModel()])
                mutableState.sections = [sectionModel, loadMoreSectionModel]
            } else {
                mutableState.sections = [sectionModel]
            }
            single(.success(mutableState))
            return Disposables.create()
        }).asObservable()
    }
    
    
    private static func makeUserSectionModel(users: [User]) -> SectionModel {
        let items = users.map(UserItemModel.init)
        return DefaultSectionModel(items: items)
    }
    
    private static func makeRepoSectionModel(repos: [Repo]) -> SectionModel {
        let items = repos.map(RepoItemModel.init)
        return DefaultSectionModel(items: items)
    }
}
