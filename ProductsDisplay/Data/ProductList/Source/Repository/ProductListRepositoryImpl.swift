//
//  ProductListRepositoryImpl.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import RxSwift

public struct ProductListRepositoryImpl: ProductListRepository {

    private let remoteProductListDataSource: RemoteProductListDataSource

    public init(remoteProductListDataSource: RemoteProductListDataSource) {
        self.remoteProductListDataSource = remoteProductListDataSource
    }

    public func fetchProducts() -> Single<ProductListEntity> {
        return remoteProductListDataSource
            .fetchProducts()
            .map { $0.toEntity() }
    }
}

