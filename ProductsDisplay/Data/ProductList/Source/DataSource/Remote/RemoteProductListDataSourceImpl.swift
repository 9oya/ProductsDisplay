//
//  RemoteProductListDataSourceImpl.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import Foundation

import RxSwift
import RxMoya

struct RemoteProductListDataSourceImpl: RemoteProductListDataSource {

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func fetchProducts() -> Single<ProductListDTO> {
        let endpoint = ProductListAPI.fetchProducts
        return networkManager.request(endpoint)
            .map(ProductListDTO.self)
    }
}
