//
//  SectionModel.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/13/24.
//

import Foundation
import UIKit

enum SectionKind: String {
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

    init(contentType: ContentType) {
        switch contentType {
        case .banner:
            self = .banner
        case .grid:
            self = .grid
        case .scroll:
            self = .scroll
        case .style:
            self = .style
        }
    }
}

struct SectionModel: Hashable {
    let kind: SectionKind
    var items: [Item]

    init(contentType: ContentType, items: [Item]) {
        self.kind = SectionKind(contentType: contentType)
        self.items = items
    }
}

struct Item: Hashable {
    let banner: Banner?
    let goods: Goods?
    let style: Style?
    let identifier = UUID()

    init(
        banner: ProductListEntity.Banner? = nil,
        goods: ProductListEntity.Goods? = nil,
        style: ProductListEntity.Style? = nil
    ) {
        if let banner = banner {
            self.banner = .init(
                linkURL: banner.linkURL,
                thumbnailURL: banner.thumbnailURL,
                title: banner.title,
                description: banner.description,
                keyword: banner.keyword
            )
        } else {
            self.banner = nil
        }

        if let goods = goods {
            self.goods = .init(
                linkURL: goods.linkURL,
                thumbnailURL: goods.thumbnailURL,
                brandName: goods.brandName,
                price: goods.price,
                saleRate: goods.saleRate,
                hasCoupon: goods.hasCoupon
            )
        } else {
            self.goods = nil
        }

        if let style = style {
            self.style = .init(
                linkURL: style.linkURL,
                thumbnailURL: style.thumbnailURL
            )
        } else {
            self.style = nil
        }
    }

    struct Banner: Hashable {
        let linkURL: String
        let thumbnailURL: String
        let title: String
        let description: String
        let keyword: String

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
}
