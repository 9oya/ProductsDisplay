//
//  ProductListAPI.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import Foundation

import Moya

public enum ProductListAPI {

    case fetchProducts
}

extension ProductListAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://meta.musinsa.com/")!
    }

    public var path: String {
        switch self {
        case .fetchProducts:
            return "interview/list.json"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchProducts:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case .fetchProducts:
            return .requestPlain
        }
    }

    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}

