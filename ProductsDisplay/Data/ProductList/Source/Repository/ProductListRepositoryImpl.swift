//
//  ProductListRepositoryImpl.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import RxSwift

struct ProductListRepositoryImpl: ProductListRepository {

    private let remoteProductListDataSource: RemoteProductListDataSource

    init(remoteProductListDataSource: RemoteProductListDataSource) {
        self.remoteProductListDataSource = remoteProductListDataSource
    }

    func fetchProducts() -> Single<ProductListEntity> {
        return remoteProductListDataSource
            .fetchProducts()
            .map { $0.toEntity() }
    }
}

