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
        }
        return newState
    }
}
