//
//  SectionModel.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/13/24.
//

import Foundation
import UIKit

public enum SectionKind: String {
    case banner = "BANNER"
    case grid = "GRID"
    case scroll = "SCROLL"
    case style = "STYLE"

    var itemsPerPage: Int {
        switch self {
        case .banner, .scroll:
            // 페이징 없음
            return 0
        case .grid:
            return 6
        case .style:
            return 6
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

public struct SectionModel: Hashable {
    public let kind: SectionKind
    public var items: [Item]
    public let header: Header?
    public let footer: Footer?

    init(
        contentType: ContentType,
        items: [Item],
        footer: Footer?,
        header: Header?
    ) {
        self.kind = SectionKind(contentType: contentType)
        self.items = items
        self.footer = footer
        self.header = header
    }

    public struct Footer: Hashable {
        let type: FooterType
        let title: String
        let iconURL: String?

        init(type: FooterType, title: String, iconURL: String?) {
            self.type = type
            self.title = title
            self.iconURL = iconURL
        }
    }

    public struct Header: Hashable {
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

public struct Item: Hashable {
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

    public struct Banner: Hashable {
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

    public struct Goods: Hashable {
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

    public struct Style: Hashable {
        let linkURL: String
        let thumbnailURL: String

        init(linkURL: String, thumbnailURL: String) {
            self.linkURL = linkURL
            self.thumbnailURL = thumbnailURL
        }
    }
}
