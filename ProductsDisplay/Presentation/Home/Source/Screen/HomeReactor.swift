//
//  HomeReactor.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import Foundation

import RxSwift
import RxCocoa
import ReactorKit
import RxFlow

class HomeReactor: Reactor, Stepper {

    var initialState: State
    var steps: PublishRelay<Step> = PublishRelay<Step>()

    private let productListUseCase: ProductListUseCase

    init(productListUseCase: ProductListUseCase) {
        self.productListUseCase = productListUseCase
        self.initialState = State()
    }

    struct State {
        var sections: [SectionModel] = []
        var prevPages: [Int] = []
        var currentPages: [Int] = []
    }

    enum Action {
        case viewDidLoad
        case moreButtonDidTap(sectionIndex: Int)
        case refreshButtonDidTap(sectionIndex: Int)
    }

    enum Mutation {
        case setSections([SectionModel])
        case setPages(sectionIndex: Int)
        case setItems(sectionIndex: Int)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return productListUseCase
                .fetchProducts()
                .asObservable()
                .map(toSectionModels(from:))
                .map { .setSections($0) }
        case .moreButtonDidTap(let sectionIndex):
            return .just(.setPages(sectionIndex: sectionIndex))
        case .refreshButtonDidTap(let sectionIndex):
            return .just(.setItems(sectionIndex: sectionIndex))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSections(let sections):
            newState.sections = sections
            newState.currentPages = sections.map { _ in 1 }
            newState.prevPages = newState.currentPages
        case .setPages(let sectionIndex):
            newState.prevPages = newState.currentPages
            newState.currentPages[sectionIndex] += 1
        case .setItems(let sectionIndex):
            newState.sections[sectionIndex].items = newState.sections[sectionIndex].items.shuffled()
        }
        return newState
    }
}

extension HomeReactor {

    func toSectionModels(from entity: ProductListEntity) -> [SectionModel] {
        let sections: [SectionModel] = entity.data.map { data in
            let contentType = data.contents.type
            var footer: SectionModel.Footer?
            if let _footer = data.footer {
                footer = .init(type: _footer.type, title: _footer.title, iconURL: _footer.iconURL)
            }
            var header: SectionModel.Header?
            if let _header = data.header {
                header = .init(title: _header.title, iconURL: _header.iconURL, linkURL: _header.linkURL)
            }
            if let _banners = data.contents.banners {
                return .init(
                    contentType: contentType,
                    items: _banners.map { .init(banner: $0) },
                    footer: footer,
                    header: header
                )
            }
            if let _goods = data.contents.goods {
                return .init(
                    contentType: contentType,
                    items: _goods.map { .init(goods: $0) },
                    footer: footer,
                    header: header
                )
            }
            if let _styles = data.contents.styles {
                return .init(
                    contentType: contentType,
                    items: _styles.map { .init(style: $0) },
                    footer: footer,
                    header: header
                )
            }
            return .init(
                contentType: contentType,
                items: [],
                footer: nil,
                header: nil
            )
        }
        return sections
    }
}
