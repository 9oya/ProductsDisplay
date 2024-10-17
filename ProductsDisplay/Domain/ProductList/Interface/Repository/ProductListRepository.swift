//
//  ProductListRepository.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import RxSwift

public protocol ProductListRepository {

    func fetchProducts() -> Single<ProductListEntity>
}
