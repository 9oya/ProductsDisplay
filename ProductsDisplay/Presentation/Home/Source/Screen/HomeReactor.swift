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

    struct State {
    }

    enum Action {
    }

    enum Mutation {
    }

    init() {
        initialState = State()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        return Observable.empty()
    }

    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}
