//
//  ProductListUseCaseTests.swift
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

final class ProductListUseCaseTests: XCTestCase {

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockProductListRepository: MockProductListRepository!
    var productListUseCase: ProductListUseCase!

    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockProductListRepository = MockProductListRepository()
        productListUseCase = ProductListUseCaseImpl(
            productListRepository: mockProductListRepository
        )
    }

    override func tearDownWithError() throws {
        scheduler = nil
        disposeBag = nil
        productListUseCase = nil
        mockProductListRepository = nil
    }

    func testFetchProducts() {
        // when
        productListUseCase.fetchProducts()
            .asObservable()
            .subscribe()
            .disposed(by: disposeBag)

        // then
        XCTAssertEqual(mockProductListRepository.isFetchProductsCalled, true)
    }
}

class MockProductListRepository: ProductListRepository {

    var isFetchProductsCalled = false

    func fetchProducts() -> Single<ProductListEntity> {
        self.isFetchProductsCalled = true
        return Single.just(.init(data: []))
    }
}
