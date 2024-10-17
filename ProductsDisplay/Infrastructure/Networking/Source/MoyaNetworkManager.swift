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

public class MoyaNetworkManager: NetworkManager {

    private let provider: MoyaProvider<MultiTarget>
    private let loggerPlugin: PluginType

    public init(
        loggerPlugin: PluginType,
        provider: MoyaProvider<MultiTarget>
    ) {
        self.loggerPlugin = loggerPlugin
        self.provider = provider
    }

    public func request(_ endpoint: any Moya.TargetType) -> Single<Moya.Response> {
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
