//
//  MakeSectionModel.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import ReactComponentKit
import RxSwift
import ReactComponentKit

extension SearchViewModel {
    func makeSectionModel(state: SearchState) -> SearchState {
        let sectionModel: DefaultSectionModel
        switch state.searchScope {
        case .user:
            guard !state.users.isEmpty else { return state }
            sectionModel = makeUserSectionModel(users: state.users)
            return state.copy {
                $0.canLoadMore = ($0.users.count > 0 && $0.users.count % $0.perPage == 0)
                if $0.canLoadMore {
                    let loadMoreSectionModel = DefaultSectionModel(items: [LoadMoreItemModel()])
                    $0.sections = [sectionModel, loadMoreSectionModel]
                } else {
                    $0.sections = [sectionModel]
                }
            }
        case .repo:
            guard !state.repos.isEmpty else { return state }
            sectionModel = makeRepoSectionModel(repos: state.repos)
            return state.copy {
                $0.canLoadMore = ($0.repos.count > 0 && $0.repos.count % $0.perPage == 0)
                if $0.canLoadMore {
                    let loadMoreSectionModel = DefaultSectionModel(items: [LoadMoreItemModel()])
                    $0.sections = [sectionModel, loadMoreSectionModel]
                } else {
                    $0.sections = [sectionModel]
                }
            }
        }
    }
    
    
    private func makeUserSectionModel(users: [User]) -> DefaultSectionModel {
        let items = users.map(UserItemModel.init)
        return DefaultSectionModel(items: items)
    }
    
    private func makeRepoSectionModel(repos: [Repo]) -> DefaultSectionModel {
        let items = repos.map(RepoItemModel.init)
        return DefaultSectionModel(items: items)
    }
}
