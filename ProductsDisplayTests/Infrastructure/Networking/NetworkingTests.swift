//
//  NetworkingTests.swift
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

final class NetworkingTests: XCTestCase {

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var networkManager: NetworkManager!
    var mockLoggerPlugin: PluginType!
    var moyaStubProvider: MoyaProvider<MultiTarget>!

    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockLoggerPlugin = MockLoggerPlugin()
        moyaStubProvider = MoyaProvider<MultiTarget>(stubClosure: MoyaProvider.immediatelyStub)
        networkManager = MoyaNetworkManager(
            loggerPlugin: mockLoggerPlugin,
            provider: moyaStubProvider
        )
    }

    override func tearDownWithError() throws {
        networkManager = nil
        mockLoggerPlugin = nil
        moyaStubProvider = nil
    }

    func testRequest() {
        // given
        let expected = MockModel(name: "Hello", age: 99)
        let observer = scheduler.createObserver(MockModel.self)

        // when
        networkManager.request(MockTargetType())
            .map(MockModel.self)
            .asDriver { error in
                return .just(.init(name: "", age: 0))
            }
            .drive(observer)
            .disposed(by: disposeBag)

        scheduler.start()

        // then
        XCTAssertEqual(
            observer.events,
            [
                .next(0, expected),
                .completed(0)
            ]
        )
    }

}

struct MockModel: Codable, Equatable {
    let name: String
    let age: Int
}

class MockLoggerPlugin: PluginType {

    var request: RequestType?
    var target: TargetType?

    func willSend(_ request: any RequestType, target: any TargetType) {
        self.request = request
        self.target = target
    }
}

class MockTargetType: TargetType {

    var baseURL: URL {
        return URL(string: "https://www.google.com/")!
    }

    var path: String {
        return ""
    }

    var method: Moya.Method {
        return .get
    }

    var task: Moya.Task {
        return .requestPlain
    }

    var headers: [String : String]?

    var sampleData: Data {
        return Data("""
        {
        "name": "Hello",
        "age": 99
        }
        """.utf8)
    }
}
