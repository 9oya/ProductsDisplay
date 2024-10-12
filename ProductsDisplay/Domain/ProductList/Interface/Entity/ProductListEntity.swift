//
//  ProductListEntity.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import Foundation

struct ProductListEntity {
    let data: [Datum]

    init(data: [Datum]) {
        self.data = data
    }

    struct Datum {
        let contents: Contents
        let header: Header?
        let footer: Footer?

        init(contents: Contents, header: Header?, footer: Footer?) {
            self.contents = contents
            self.header = header
            self.footer = footer
        }
    }

    struct Contents {
        let type: String
        let banners: [Banner]?
        let goods: [Goods]?
        let styles: [Style]?

        init(type: String, banners: [Banner]?, goods: [Goods]?, styles: [Style]?) {
            self.type = type
            self.banners = banners
            self.goods = goods
            self.styles = styles
        }
    }

    struct Banner {
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

    struct Goods {
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

    struct Style {
        let linkURL: String
        let thumbnailURL: String

        init(linkURL: String, thumbnailURL: String) {
            self.linkURL = linkURL
            self.thumbnailURL = thumbnailURL
        }
    }

    struct Footer {
        let type, title: String
        let iconURL: String?

        init(type: String, title: String, iconURL: String?) {
            self.type = type
            self.title = title
            self.iconURL = iconURL
        }
    }

    struct Header {
        let title: String
        let iconURL: String?
        let linkURL: String?

        init(title: String, iconURL: String?, linkURL: String?) {
            self.title = title
            self.iconURL = iconURL
            self.linkURL = linkURL
        }
    }
}
