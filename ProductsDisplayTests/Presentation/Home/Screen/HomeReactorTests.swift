//
//  HomeReactorTests.swift
//  ProductsDisplayTests
//
//  Created by 9oya on 10/17/24.
//

import XCTest

import ProductsDisplay
import Moya
import RxMoya
import RxSwift
import RxBlocking
import RxTest

final class HomeReactorTests: XCTestCase {

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockProductListUseCase: MockProductListUseCase!
    var homeReactor: HomeReactor!

    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockProductListUseCase = MockProductListUseCase()
        homeReactor = HomeReactor(productListUseCase: mockProductListUseCase)
    }

    override func tearDownWithError() throws {
        scheduler = nil
        disposeBag = nil
        mockProductListUseCase = nil
        homeReactor = nil
    }

    func testViewDidLoadAction() {
        // given
        let entity = ProductListEntity(data: [.init(contents: .init(type: ContentType.banner.rawValue, banners: [], goods: nil, styles: nil), header: nil, footer: nil)])
        mockProductListUseCase.stubbedProductListEntity = entity

        // when
        homeReactor.action.onNext(.viewDidLoad)

        // then
        XCTAssertEqual(homeReactor.currentState.sections.count, 1)
        XCTAssertEqual(homeReactor.currentState.sections.first?.kind, SectionKind.banner)
        XCTAssertEqual(homeReactor.currentState.currentPages.count, 1)
        XCTAssertEqual(homeReactor.currentState.prevPages.count, 1)
    }

    func testMoreButtonDidTapAction() {
        // given
        let entity = ProductListEntity(data: [.init(contents: .init(type: ContentType.banner.rawValue, banners: [], goods: nil, styles: nil), header: nil, footer: nil)])
        mockProductListUseCase.stubbedProductListEntity = entity

        // when
        scheduler.createHotObservable([
            .next(0, .viewDidLoad),
            .next(10, .moreButtonDidTap(sectionIndex: 0))
        ])
        .subscribe(homeReactor.action)
        .disposed(by: disposeBag)

        // then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.homeReactor.state.map { $0.currentPages }
        }
        XCTAssertEqual(response.events.map { $0.value.element }, [
            [1],
            [2]
        ])
    }

    func testRefreshAction() {
        // given
        let sectionIndex = 0
        let banners: [ProductListEntity.Banner] = [
            .init(linkURL: "", thumbnailURL: "", title: "", description: "", keyword: ""),
            .init(linkURL: "", thumbnailURL: "", title: "", description: "", keyword: ""),
            .init(linkURL: "", thumbnailURL: "", title: "", description: "", keyword: "")
        ]
        let entity = ProductListEntity(data: [.init(contents: .init(type: ContentType.banner.rawValue, banners: banners, goods: nil, styles: nil), header: nil, footer: nil)])
        mockProductListUseCase.stubbedProductListEntity = entity
        let prevSectionModels = homeReactor.toSectionModels(from: entity)

        // when
        scheduler.createHotObservable([
            .next(0, .viewDidLoad),
            .next(10, .refreshButtonDidTap(sectionIndex: sectionIndex))
        ])
        .subscribe(homeReactor.action)
        .disposed(by: disposeBag)

        // then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.homeReactor.state.map { $0.sections[sectionIndex].items }
        }
        XCTAssertNotEqual(response.events, [
            .next(0, prevSectionModels.first!.items),
            .next(10, prevSectionModels.first!.items)
        ])
    }

    func testBannerPageIsChanged() {
        // given
        let sectionIndex = 0
        let banners: [ProductListEntity.Banner] = [
            .init(linkURL: "", thumbnailURL: "", title: "", description: "", keyword: ""),
            .init(linkURL: "", thumbnailURL: "", title: "", description: "", keyword: ""),
            .init(linkURL: "", thumbnailURL: "", title: "", description: "", keyword: "")
        ]
        let entity = ProductListEntity(data: [.init(contents: .init(type: ContentType.banner.rawValue, banners: banners, goods: nil, styles: nil), header: nil, footer: nil)])
        mockProductListUseCase.stubbedProductListEntity = entity

        // when
        scheduler.createHotObservable([
            .next(0, .viewDidLoad),
            .next(10, .bannerPageIsChanged(index: 1)),
            .next(20, .bannerPageIsChanged(index: 2)),
            .next(30, .bannerPageIsChanged(index: 3))
        ])
        .subscribe(homeReactor.action)
        .disposed(by: disposeBag)

        // then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.homeReactor.state.map { $0.bannerPageIndex }
        }
        XCTAssertEqual(response.events, [
            .next(0, 0),
            .next(10, 1),
            .next(20, 2),
            .next(30, 3)
        ])
    }
}

class MockProductListUseCase: ProductListUseCase {

    var stubbedProductListEntity: ProductListEntity?

    func fetchProducts() -> Single<ProductListEntity> {
        return Single.just(stubbedProductListEntity ?? .init(data: []))
    }
}
