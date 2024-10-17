//
//  RemoteProductListDataSourceTests.swift
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

final class RemoteProductListDataSourceTests: XCTestCase {

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockNetworkManager: MockNetworkManager!
    var remoteProductListDataSource: RemoteProductListDataSource!

    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockNetworkManager = MockNetworkManager()
        remoteProductListDataSource = RemoteProductListDataSourceImpl(networkManager: mockNetworkManager)
    }

    override func tearDownWithError() throws {
        mockNetworkManager = nil
        remoteProductListDataSource = nil
    }

    func testFetchProducts() {
        // when
        remoteProductListDataSource.fetchProducts()
            .asObservable()
            .subscribe()
            .disposed(by: disposeBag)

        // then
        let expectedEndpoint = ProductListAPI.fetchProducts
        XCTAssertEqual(expectedEndpoint.path, mockNetworkManager.endpoint?.path)
    }

}

class MockNetworkManager: NetworkManager {

    var endpoint: TargetType?

    func request(_ endpoint: TargetType) -> Single<Response> {

        self.endpoint = endpoint

        return Single.just(Response(statusCode: 200, data: Data()))
    }
}
