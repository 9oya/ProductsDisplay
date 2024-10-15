//
//  Extension+Container+ProudctListData.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import Factory

extension Container {

    var remoteProductListDataSource: Factory<RemoteProductListDataSource> {
        self {
            let networkManager = Container.shared.networkManager()
            return RemoteProductListDataSourceImpl(networkManager: networkManager)
        }
    }
}
