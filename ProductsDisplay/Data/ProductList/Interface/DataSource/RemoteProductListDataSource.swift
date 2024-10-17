//
//  RemoteProductListDataSource.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import RxSwift

public protocol RemoteProductListDataSource {

    func fetchProducts() -> Single<ProductListDTO>
}
