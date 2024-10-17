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

public class HomeReactor: Reactor, Stepper {

    public var initialState: State
    public var steps: PublishRelay<Step> = PublishRelay<Step>()

    private let productListUseCase: ProductListUseCase

    public init(productListUseCase: ProductListUseCase) {
        self.productListUseCase = productListUseCase
        self.initialState = State()
    }

    public struct State {
        public var sections: [SectionModel] = []
        public var prevPages: [Int] = []
        public var currentPages: [Int] = []
        public var bannerPageIndex: Int = 0
    }

    public enum Action {
        case viewDidLoad
        case moreButtonDidTap(sectionIndex: Int)
        case refreshButtonDidTap(sectionIndex: Int)
        case bannerPageIsChanged(index: Int)
    }

    public enum Mutation {
        case setSections(sections: [SectionModel], pages: [Int])
        case setPages(sectionIndex: Int)
        case setItems(sectionIndex: Int, items: [Item])
        case setBannerPage(index: Int)
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return productListUseCase
                .fetchProducts()
                .asObservable()
                .map(toSectionModels(from:))
                .map { sections in
                    let pages = sections.map { _ in 1 }
                    return .setSections(
                        sections: sections,
                        pages: pages
                    )
                }
        case .moreButtonDidTap(let sectionIndex):
            return .just(.setPages(sectionIndex: sectionIndex))
        case .refreshButtonDidTap(let sectionIndex):
            let shuffledItems = currentState.sections[sectionIndex].items.shuffled()
            return .just(.setItems(
                sectionIndex: sectionIndex,
                items: shuffledItems
            ))
        case .bannerPageIsChanged(let index):
            return .just(.setBannerPage(index: index))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSections(sections, pages):
            newState.sections = sections
            newState.currentPages = pages
            newState.prevPages = newState.currentPages
        case .setPages(let sectionIndex):
            newState.prevPages = newState.currentPages
            newState.currentPages[sectionIndex] += 1
        case let .setItems(sectionIndex, items):
            newState.sections[sectionIndex].items = items
        case .setBannerPage(let index):
            newState.bannerPageIndex = index
        }
        return newState
    }
}

extension HomeReactor {

    public func toSectionModels(from entity: ProductListEntity) -> [SectionModel] {
        let sections: [SectionModel] = entity.data.map { data in
            let contentType = data.contents.type
            var footer: SectionModel.Footer?
            if let _footer = data.footer {
                footer = .init(
                    type: _footer.type,
                    title: _footer.title,
                    iconURL: _footer.iconURL
                )
            }
            var header: SectionModel.Header?
            if let _header = data.header {
                header = .init(
                    title: _header.title,
                    iconURL: _header.iconURL,
                    linkURL: _header.linkURL
                )
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
                footer: footer,
                header: header
            )
        }
        return sections
    }
}
