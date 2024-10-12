//
//  Extension+Container+HomePresentation.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import Factory

extension Container {

    var home: Factory<Home> {
        self {
            HomeImpl()
        }
    }
}

