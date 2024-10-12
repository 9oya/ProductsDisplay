//
//  ProductListUseCaseImpl.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import RxSwift

struct ProductListUseCaseImpl: ProductListUseCase {

    private let productListRepository: ProductListRepository

    init(productListRepository: ProductListRepository) {
        self.productListRepository = productListRepository
    }

    func fetchProducts() -> Single<ProductListEntity> {
        return productListRepository.fetchProducts()
    }
}
