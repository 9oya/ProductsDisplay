//
//  NetworkManager.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import Moya
import RxSwift

public protocol NetworkManager {

    func request(_ endpoint: TargetType) -> Single<Response>
}
