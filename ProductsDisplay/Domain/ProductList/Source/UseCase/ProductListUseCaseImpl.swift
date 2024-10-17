//
//  ProductListUseCaseImpl.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import RxSwift

public struct ProductListUseCaseImpl: ProductListUseCase {

    private let productListRepository: ProductListRepository

    public init(productListRepository: ProductListRepository) {
        self.productListRepository = productListRepository
    }

    public func fetchProducts() -> Single<ProductListEntity> {
        return productListRepository.fetchProducts()
    }
}
