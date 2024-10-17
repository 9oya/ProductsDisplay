//
//  PDLabelConfig.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/17/24.
//

import UIKit

public struct PDLabelConfig {
    var font: UIFont
    var color: UIColor
    var textAlignment: NSTextAlignment

    public init(font: UIFont, color: UIColor, textAlignment: NSTextAlignment) {
        self.font = font
        self.color = color
        self.textAlignment = textAlignment
    }
}
