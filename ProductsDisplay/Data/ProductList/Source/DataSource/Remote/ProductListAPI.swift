//
//  ProductListAPI.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import Foundation

import Moya

enum ProductListAPI {

    case fetchProducts
}

extension ProductListAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://meta.musinsa.com/")!
    }

    var path: String {
        switch self {
        case .fetchProducts:
            return "interview/list.json"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchProducts:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .fetchProducts:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}

