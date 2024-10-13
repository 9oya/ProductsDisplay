//
//  ProductListEntity.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import Foundation
import UIKit

enum ContentType: String {
    case banner = "BANNER"
    case grid = "GRID"
    case scroll = "SCROLL"
    case style = "STYLE"

    var columnCount: Int {
        switch self {
        case .banner:
            return 1
        default:
            return 2
        }
    }

    func orthogonalScrollingBehavior() -> UICollectionLayoutSectionOrthogonalScrollingBehavior {
        switch self {
        case .banner:
            return .groupPagingCentered
        default:
            return .none
        }
    }
}

enum FooterType: String {
    case refresh = "REFRESH"
    case more = "MORE"
}

enum HeaderType {
    case normal
    case all
    case icon
}

struct ProductListEntity: Equatable {
    let data: [Datum]

    init(data: [Datum]) {
        self.data = data
    }

    struct Datum: Equatable {
        static func == (lhs: ProductListEntity.Datum, rhs: ProductListEntity.Datum) -> Bool {
            return lhs.contents == rhs.contents && lhs.header == rhs.header && lhs.footer == rhs.footer
        }
        
        let contents: Contents
        let header: Header?
        let footer: Footer?

        init(contents: Contents, header: Header?, footer: Footer?) {
            self.contents = contents
            self.header = header
            self.footer = footer
        }
    }

    struct Contents: Equatable {
        let type: ContentType
        var banners: [Banner]?
        var goods: [Goods]?
        var styles: [Style]?

        init(type: String, banners: [Banner]?, goods: [Goods]?, styles: [Style]?) {
            self.type = ContentType(rawValue: type)!
            self.banners = banners
            self.goods = goods
            self.styles = styles
        }
    }

    struct Banner: Hashable {
        let linkURL: String
        let thumbnailURL: String
        let title, description, keyword: String

        init(linkURL: String, thumbnailURL: String, title: String, description: String, keyword: String) {
            self.linkURL = linkURL
            self.thumbnailURL = thumbnailURL
            self.title = title
            self.description = description
            self.keyword = keyword
        }
    }

    struct Goods: Hashable {
        let linkURL: String
        let thumbnailURL: String
        let brandName: String
        let price, saleRate: Int
        let hasCoupon: Bool

        init(linkURL: String, thumbnailURL: String, brandName: String, price: Int, saleRate: Int, hasCoupon: Bool) {
            self.linkURL = linkURL
            self.thumbnailURL = thumbnailURL
            self.brandName = brandName
            self.price = price
            self.saleRate = saleRate
            self.hasCoupon = hasCoupon
        }
    }

    struct Style: Hashable {
        let linkURL: String
        let thumbnailURL: String

        init(linkURL: String, thumbnailURL: String) {
            self.linkURL = linkURL
            self.thumbnailURL = thumbnailURL
        }
    }

    struct Footer: Equatable {
        let type: FooterType
        let title: String
        let iconURL: String?

        init(type: String, title: String, iconURL: String?) {
            self.type = FooterType(rawValue: type)!
            self.title = title
            self.iconURL = iconURL
        }
    }

    struct Header: Equatable {
        let type: HeaderType
        let title: String
        let iconURL: String?
        let linkURL: String?

        init(title: String, iconURL: String?, linkURL: String?) {
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
