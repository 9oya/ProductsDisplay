//
//  FooterCollectionResusableView.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/13/24.
//

import UIKit

import Then
import SnapKit
import RxSwift

class FooterCollectionResusableView: UICollectionReusableView {

    var disposeBag = DisposeBag()
    var button: UIButton!

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        button = UIButton().then {
            $0.setBorder(
                radius: 30,
                color: .systemGray5,
                width: 1
            )
        }
        addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(15)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func apply(footerType: FooterType) {
        var title = ""
        switch footerType {
        case .more:
            title = "더보기"
        case .refresh:
            title = "새로운 추천"
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 15))
            let image = UIImage(systemName: "arrow.clockwise", withConfiguration: config)
            button.setImage(image: image, padding: 5)
            button.tintColor = .systemGray
        }
        button.setTitle(
            text: title,
            font: .systemFont(
                ofSize: 15,
                weight: .bold
            ),
            color: .label
        )
    }
}

extension UIButton {

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
        padding: CGFloat,
        contentInsets: NSDirectionalEdgeInsets? = nil
    ) {
        let renderedImage = image?.withRenderingMode(renderingMode)
        semanticContentAttribute = attr

        if configuration == nil { configuration = .plain() }

        configuration?.image = renderedImage
        configuration?.imagePadding = padding
        if let contentInsets = contentInsets {
            configuration?.contentInsets = contentInsets
        }
    }

    func setTitle(
        text: String,
        font: UIFont,
        color: UIColor,
        titleAlignment: UIButton.Configuration.TitleAlignment = .automatic,
        lineBreakMode: NSLineBreakMode? = nil,
        contentInsets: NSDirectionalEdgeInsets? = nil
    ) {
        if configuration == nil { configuration = .plain() }

        var attrStr = AttributedString(text)
        attrStr.font = font

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
