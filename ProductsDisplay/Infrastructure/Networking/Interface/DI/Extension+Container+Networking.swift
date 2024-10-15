//
//  Extension+Container+Networking.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import Factory

extension Container {

    var networkManager: Factory<NetworkManager> {
        self {
            let loggerPlugin = LoggerPlugin()
            return MoyaNetworkManager(loggerPlugin: loggerPlugin)
        }
    }
}
