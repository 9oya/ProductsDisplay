//
//  ProductListEntity.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import Foundation

public enum ContentType: String {
    case banner = "BANNER"
    case grid = "GRID"
    case scroll = "SCROLL"
    case style = "STYLE"
}

public enum FooterType: String {
    case refresh = "REFRESH"
    case more = "MORE"
}

public enum HeaderType {
    case normal
    case all
    case icon
}

public struct ProductListEntity: Equatable {
    let data: [Datum]

    public init(data: [Datum]) {
        self.data = data
    }

    public struct Datum: Equatable {
        public static func == (lhs: ProductListEntity.Datum, rhs: ProductListEntity.Datum) -> Bool {
            return lhs.contents == rhs.contents && lhs.header == rhs.header && lhs.footer == rhs.footer
        }
        
        public let contents: Contents
        public let header: Header?
        public let footer: Footer?

        public init(contents: Contents, header: Header?, footer: Footer?) {
            self.contents = contents
            self.header = header
            self.footer = footer
        }
    }

    public struct Contents: Equatable {
        public let type: ContentType
        public let banners: [Banner]?
        public let goods: [Goods]?
        public let styles: [Style]?

        public init(type: String, banners: [Banner]?, goods: [Goods]?, styles: [Style]?) {
            self.type = ContentType(rawValue: type)!
            self.banners = banners
            self.goods = goods
            self.styles = styles
        }
    }

    public struct Banner: Equatable {
        public let linkURL: String
        public let thumbnailURL: String
        public let title, description, keyword: String

        public init(linkURL: String, thumbnailURL: String, title: String, description: String, keyword: String) {
            self.linkURL = linkURL
            self.thumbnailURL = thumbnailURL
            self.title = title
            self.description = description
            self.keyword = keyword
        }
    }

    public struct Goods: Equatable {
        public let linkURL: String
        public let thumbnailURL: String
        public let brandName: String
        public let price, saleRate: Int
        public let hasCoupon: Bool

        public init(linkURL: String, thumbnailURL: String, brandName: String, price: Int, saleRate: Int, hasCoupon: Bool) {
            self.linkURL = linkURL
            self.thumbnailURL = thumbnailURL
            self.brandName = brandName
            self.price = price
            self.saleRate = saleRate
            self.hasCoupon = hasCoupon
        }
    }

    public struct Style: Equatable {
        let linkURL: String
        let thumbnailURL: String

        public init(linkURL: String, thumbnailURL: String) {
            self.linkURL = linkURL
            self.thumbnailURL = thumbnailURL
        }
    }

    public struct Footer: Equatable {
        let type: FooterType
        let title: String
        let iconURL: String?

        public init(type: String, title: String, iconURL: String?) {
            self.type = FooterType(rawValue: type)!
            self.title = title
            self.iconURL = iconURL
        }
    }

    public struct Header: Equatable {
        let type: HeaderType
        let title: String
        let iconURL: String?
        let linkURL: String?

        public init(title: String, iconURL: String?, linkURL: String?) {
            self.title = title
            self.iconURL = iconURL
            self.linkURL = linkURL

            var type: HeaderType
            if linkURL != nil {
                type = .all
            } else if iconURL != nil {
                type = .icon
            } else {
                type = .normal
            }
            self.type = type
        }
    }
}
