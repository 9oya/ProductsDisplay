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
        var products: ProductListEntity?
        var sections: [SectionModel]?
    }

    enum Action {
        case viewDidLoad
    }

    enum Mutation {
        case setProducts(ProductListEntity)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return productListUseCase
                .fetchProducts()
                .asObservable()
                .map { .setProducts($0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setProducts(let entity):
            newState.products = entity

            let sections: [SectionModel] = entity.data.map { data in
                if let _banners = data.contents.banners {
                    return .init(
                        contentType: data.contents.type,
                        items: _banners.map { .init(banner: $0) }
                    )
                }
                if let _goods = data.contents.goods {
                    return .init(
                        contentType: data.contents.type,
                        items: _goods.map { .init(goods: $0) }
                    )
                }
                if let _styles = data.contents.styles {
                    return .init(
                        contentType: data.contents.type,
                        items: _styles.map { .init(style: $0) }
                    )
                }
                return .init(
                    contentType: data.contents.type,
                    items: []
                )
            }
            newState.sections = sections

        }
        return newState
    }
}
