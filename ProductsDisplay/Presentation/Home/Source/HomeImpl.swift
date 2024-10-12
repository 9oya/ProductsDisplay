//
//  HomeImpl.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import UIKit

import RxFlow

class HomeImpl: Home {

    func makeFlow() -> Flow {
        return HomeFlow()
    }
}
