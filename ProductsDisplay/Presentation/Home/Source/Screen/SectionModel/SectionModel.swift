//
//  SectionModel.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/13/24.
//

import Foundation

enum SectionKind: String, CaseIterable {
    case banner = "BANNER"
    case grid = "GRID"
    case scroll = "SCROLL"
    case style = "STYLE"
}

struct Item: Hashable {
    let banner: ProductListEntity.Banner?
    let goods: ProductListEntity.Goods?
    let style: ProductListEntity.Style?
    let identifier = UUID()

    init(
        banner: ProductListEntity.Banner? = nil,
        goods: ProductListEntity.Goods? = nil,
        style: ProductListEntity.Style? = nil) {
        self.banner = banner
        self.goods = goods
        self.style = style
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
