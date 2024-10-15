//
//  ProductListUseCase.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import RxSwift

protocol ProductListUseCase {

    func fetchProducts() -> Single<ProductListEntity>
}
