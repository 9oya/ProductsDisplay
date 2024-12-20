//
//  HeaderCollectionResusableView.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/13/24.
//

import UIKit

import Then
import SnapKit

public class HeaderCollectionResusableView: UICollectionReusableView {

    private var hStackView: UIStackView!
    public var titleLabel: UILabel!
    public var iconImageView: UIImageView!
    public var button: UIButton!

    public var itemSpacing: CGFloat = 10 {
        didSet {
            hStackView.spacing = itemSpacing
        }
    }

    public var titleLabelFont: UIFont = .systemFont(ofSize: 20, weight: .bold) {
        didSet {
            titleLabel.font = titleLabelFont
        }
    }

    public var titleLabelColor: UIColor = .label {
        didSet {
            titleLabel.textColor = titleLabelColor
        }
    }

    public var buttonTitleFont: UIFont = .systemFont(ofSize: 15, weight: .light) {
        didSet {
            button.setTitle(
                attrString: button.configuration?.attributedTitle ?? "",
                font: buttonTitleFont,
                color: buttonTitleColor
            )
        }
    }

    public var buttonTitleColor: UIColor = .systemGray {
        didSet {
            button.setTitle(
                attrString: button.configuration?.attributedTitle ?? "",
                font: buttonTitleFont,
                color: buttonTitleColor,
                titleAlignment: buttonTitleAlignment
            )
        }
    }

    public var buttonTitle: String = "전체" {
        didSet {
            button.setTitle(
                text: buttonTitle,
                font: buttonTitleFont,
                color: buttonTitleColor,
                titleAlignment: buttonTitleAlignment
            )
        }
    }

    public var buttonTitleAlignment: UIButton.Configuration.TitleAlignment = .trailing {
        didSet {
            button.setTitle(
                text: buttonTitle,
                font: buttonTitleFont,
                color: buttonTitleColor,
                titleAlignment: buttonTitleAlignment
            )
        }
    }

    public var buttonSize: CGSize = .init(width: 60, height: 60) {
        didSet {
            button.snp.updateConstraints {
                $0.width.equalTo(buttonSize.width)
                $0.height.equalTo(buttonSize.height)
            }
        }
    }

    public var iconImageSize: CGSize = .init(width: 20, height: 20) {
        didSet {
            iconImageView.snp.updateConstraints {
                $0.width.equalTo(iconImageSize.width)
                $0.height.equalTo(iconImageSize.height)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        hStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = itemSpacing
            $0.alignment = .center
        }

        titleLabel = UILabel().then {
            $0.textAlignment = .left
            $0.textColor = titleLabelColor
            $0.font = titleLabelFont
            $0.numberOfLines = 0
        }
        iconImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
        }
        button = UIButton().then {
            $0.setTitle(
                text: buttonTitle,
                font: buttonTitleFont,
                color: buttonTitleColor,
                titleAlignment: buttonTitleAlignment
            )
            $0.isHidden = true
        }

        addSubview(hStackView)
        hStackView.addArrangedSubview(titleLabel)
        hStackView.addArrangedSubview(iconImageView)
        hStackView.addHorizontalSpacer()
        addSubview(button)

        hStackView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.right.equalTo(button.snp.left)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        iconImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.width.equalTo(iconImageSize.width)
            $0.height.equalTo(iconImageSize.height)
        }
        button.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
            $0.width.equalTo(buttonSize.width)
            $0.height.equalTo(buttonSize.height)
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        iconImageView.image = nil
        button.isHidden = true
    }

    public func apply(
        title: String,
        iconURL: String?,
        linkURL: String?
    ) {
        titleLabel.text = title
        if let iconURL = iconURL, 
            let imgURL = URL(string: iconURL) {
            UIHelper.loadImage(imageURL: imgURL, imageView: iconImageView)
        }
        button.isHidden = linkURL == nil
    }
}
