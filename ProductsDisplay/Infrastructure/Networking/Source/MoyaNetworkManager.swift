//
//  MoyaNetworkManager.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift

class MoyaNetworkManager: NetworkManager {

    private lazy var provider: MoyaProvider<MultiTarget> = {
        return setupProvider()
    }()
    private let loggerPlugin: PluginType

    init(loggerPlugin: PluginType) {
        self.loggerPlugin = loggerPlugin
    }

    private func setupProvider(stubClosure: @escaping (MultiTarget) -> StubBehavior = MoyaProvider.neverStub) -> MoyaProvider<MultiTarget> {
        let session: Session = {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 6
            return Session(
                configuration: configuration
            )
        }()

        return MoyaProvider<MultiTarget>(
            endpointClosure: { target in
                MoyaProvider.defaultEndpointMapping(for: target).adding(newHTTPHeaderFields: target.headers!)
            },
            stubClosure: stubClosure,
            session: session,
            plugins: [loggerPlugin]
        )
    }

    func request(_ endpoint: any Moya.TargetType) -> Single<Moya.Response> {
        return provider.rx.request(MultiTarget(endpoint))
            .do { [weak self] response in
                self?.successPrinter()
            } onError: { [weak self] error in
                self?.errorPrinter(error)
            }
    }
}

extension MoyaNetworkManager {

    private func successPrinter() {
        print("✅ SUCCESS RESPONSE")
    }

    private func errorPrinter(_ error: Error) {
        print("❌ FAILURE")
        print("❌ ERROR: \(error)")
        print("❌ ERROR DESCRIPTION: \(error.localizedDescription)")
    }
}
