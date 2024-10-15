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
        case setProducts(ProductListEntity)
        case setPage(sectionIndex: Int)
        case setItems(sectionIndex: Int)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return productListUseCase
                .fetchProducts()
                .asObservable()
                .map { .setProducts($0) }
        case .moreButtonDidTap(let sectionIndex):
            return .just(.setPage(sectionIndex: sectionIndex))
        case .refreshButtonDidTap(let sectionIndex):
            return .just(.setItems(sectionIndex: sectionIndex))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setProducts(let entity):
            let sections: [SectionModel] = entity.data.map { data in
                let contentType = data.contents.type
                if let _banners = data.contents.banners {
                    return .init(
                        contentType: contentType,
                        items: _banners.map { .init(banner: $0) }
                    )
                }
                if let _goods = data.contents.goods {
                    return .init(
                        contentType: contentType,
                        items: _goods.map { .init(goods: $0) }
                    )
                }
                if let _styles = data.contents.styles {
                    return .init(
                        contentType: contentType,
                        items: _styles.map { .init(style: $0) }
                    )
                }
                return .init(
                    contentType: contentType,
                    items: []
                )
            }
            newState.sections = sections
            newState.currentPages = sections.map { _ in 1 }
            newState.prevPages = newState.currentPages
        case .setPage(let sectionIndex):
            newState.prevPages = newState.currentPages
            newState.currentPages[sectionIndex] += 1
        case .setItems(let sectionIndex):
            newState.sections[sectionIndex].items = newState.sections[sectionIndex].items.shuffled()
        }
        return newState
    }
}
