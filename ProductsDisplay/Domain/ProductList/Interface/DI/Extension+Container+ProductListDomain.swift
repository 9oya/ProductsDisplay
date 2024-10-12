//
//  Extension+Container+ProductListDomain.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import Factory

extension Container {

    var productListUseCase: Factory<ProductListUseCase> {
        self {
            let productListRepository = Container.shared.productListRepository()
            return ProductListUseCaseImpl(productListRepository: productListRepository)
        }
    }

    var productListRepository: Factory<ProductListRepository> {
        self {
            let remoteProductListDataSource = Container.shared.remoteProductListDataSource()
            return ProductListRepositoryImpl(remoteProductListDataSource: remoteProductListDataSource)
        }
    }
}
