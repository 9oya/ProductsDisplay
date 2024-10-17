//
//  ProductListDTO.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import Foundation

public struct ProductListDTO: Codable {
    public let data: [Datum]

    public init(data: [Datum]) {
        self.data = data
    }

    func toEntity() -> ProductListEntity {
        return .init(data: data.map { $0.toEntity() })
    }

    public struct Datum: Codable {
        let contents: Contents
        let header: Header?
        let footer: Footer?

        func toEntity() -> ProductListEntity.Datum {
            return .init(contents: contents.toEntity(), header: header?.toEntity(), footer: footer?.toEntity())
        }
    }

    struct Contents: Codable {
        let type: String
        let banners: [Banner]?
        let goods: [Goods]?
        let styles: [Style]?

        func toEntity() -> ProductListEntity.Contents {
            return .init(type: type, banners: banners?.map { $0.toEntity() }, goods: goods?.map { $0.toEntity() }, styles: styles?.map { $0.toEntity() })
        }
    }

    struct Banner: Codable {
        let linkURL: String
        let thumbnailURL: String
        let title, description, keyword: String

        func toEntity() -> ProductListEntity.Banner {
            return .init(linkURL: linkURL, thumbnailURL: thumbnailURL, title: title, description: description, keyword: keyword)
        }
    }

    struct Goods: Codable {
        let linkURL: String
        let thumbnailURL: String
        let brandName: String
        let price, saleRate: Int
        let hasCoupon: Bool

        func toEntity() -> ProductListEntity.Goods {
            return .init(linkURL: linkURL, thumbnailURL: thumbnailURL, brandName: brandName, price: price, saleRate: saleRate, hasCoupon: hasCoupon)
        }
    }

    struct Style: Codable {
        let linkURL: String
        let thumbnailURL: String

        func toEntity() -> ProductListEntity.Style {
            return .init(linkURL: linkURL, thumbnailURL: thumbnailURL)
        }
    }

    struct Footer: Codable {
        let type, title: String
        let iconURL: String?

        func toEntity() -> ProductListEntity.Footer {
            return .init(type: type, title: title, iconURL: iconURL)
        }
    }

    struct Header: Codable {
        let title: String
        let iconURL: String?
        let linkURL: String?

        func toEntity() -> ProductListEntity.Header {
            return .init(title: title, iconURL: iconURL, linkURL: linkURL)
        }
    }
}
