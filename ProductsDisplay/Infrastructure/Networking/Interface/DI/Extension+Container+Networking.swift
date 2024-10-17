//
//  Extension+Container+Networking.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import Foundation

import Factory
import Moya
import RxMoya

extension Container {

    var networkManager: Factory<NetworkManager> {
        self {
            let loggerPlugin = LoggerPlugin()
            let session: Session = {
                let configuration = URLSessionConfiguration.default
                configuration.timeoutIntervalForRequest = 6
                return Session(
                    configuration: configuration
                )
            }()
            let provider = MoyaProvider<MultiTarget>(
                endpointClosure: { target in
                    MoyaProvider.defaultEndpointMapping(for: target).adding(newHTTPHeaderFields: target.headers!)
                },
                stubClosure: MoyaProvider.neverStub,
                session: session,
                plugins: [loggerPlugin]
            )

            return MoyaNetworkManager(
                loggerPlugin: loggerPlugin,
                provider: provider
            )
        }
    }
}
