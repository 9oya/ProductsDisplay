//
//  ProductListRepositoryTests.swift
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

final class ProductListRepositoryTests: XCTestCase {

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockRemoteProductListDataSource: MockRemoteProductListDataSource!
    var productListRepository: ProductListRepository!

    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockRemoteProductListDataSource = MockRemoteProductListDataSource()
        productListRepository = ProductListRepositoryImpl(
            remoteProductListDataSource: mockRemoteProductListDataSource
        )
    }

    override func tearDownWithError() throws {
        scheduler = nil
        disposeBag = nil
        mockRemoteProductListDataSource = nil
        productListRepository = nil
    }

    func testFetchProducts() {
        // when
        productListRepository.fetchProducts()
            .asObservable()
            .subscribe()
            .disposed(by: disposeBag)

        // then
        XCTAssertEqual(
            mockRemoteProductListDataSource.isFetchProductsCalled,
            true
        )
    }

}

class MockRemoteProductListDataSource: RemoteProductListDataSource {

    var isFetchProductsCalled = false

    func fetchProducts() -> Single<ProductListDTO> {
        self.isFetchProductsCalled = true
        return Single.just(.init(data: []))
    }
}
