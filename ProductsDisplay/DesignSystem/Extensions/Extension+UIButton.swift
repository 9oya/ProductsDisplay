//
//  Extension+UIButton.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/16/24.
//

import UIKit

public extension UIButton {

    func setBorder(
        radius: CGFloat,
        color: UIColor? = nil,
        width: CGFloat = 0
    ) {
        layer.cornerRadius = radius
        layer.borderColor = color?.cgColor
        layer.borderWidth = width
    }

    func setImage(
        image: UIImage?,
        renderingMode: UIImage.RenderingMode = .alwaysOriginal,
        attr: UISemanticContentAttribute = .forceLeftToRight,
        padding: CGFloat? = nil,
        contentInsets: NSDirectionalEdgeInsets? = nil
    ) {
        let renderedImage = image?.withRenderingMode(renderingMode)
        semanticContentAttribute = attr

        if configuration == nil { configuration = .plain() }

        configuration?.image = renderedImage
        if let padding = padding {
            configuration?.imagePadding = padding
        }
        if let contentInsets = contentInsets {
            configuration?.contentInsets = contentInsets
        }
    }

    func setTitle(
        text: String = "",
        attrString: AttributedString? = nil,
        font: UIFont,
        color: UIColor,
        titleAlignment: UIButton.Configuration.TitleAlignment = .automatic,
        lineBreakMode: NSLineBreakMode? = nil,
        contentInsets: NSDirectionalEdgeInsets? = nil
    ) {
        if configuration == nil { configuration = .plain() }

        var attrStr: AttributedString
        if let attrString = attrString {
            attrStr = attrString
        } else {
            attrStr = AttributedString(text)
            attrStr.font = font
        }

        configuration?.attributedTitle = attrStr
        configuration?.baseForegroundColor = color

        if let lineBreakMode = lineBreakMode {
            configuration?.titleLineBreakMode = lineBreakMode
        }
        if let contentInsets = contentInsets {
            configuration?.contentInsets = contentInsets
        }

        configuration?.titleAlignment = titleAlignment
    }
}
