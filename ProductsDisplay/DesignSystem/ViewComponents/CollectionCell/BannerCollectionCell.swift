//
//  BannerCollectionCell.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/13/24.
//

import UIKit

import SnapKit
import Then

public class BannerCollectionCell: UICollectionViewCell {

    public var imageView: UIImageView!

    public var titleLabel: UILabel!
    public var subTitleLabel: UILabel!

    public var titleLabelConfig: PDLabelConfig = .init(
        font: .boldSystemFont(ofSize: 20),
        color: .white,
        textAlignment: .center
    ) {
        didSet {
            titleLabel.font = titleLabelConfig.font
            titleLabel.textColor = titleLabelConfig.color
            titleLabel.textAlignment = titleLabelConfig.textAlignment
        }
    }

    public var subTitleLabelConfig: PDLabelConfig = .init(
        font: .systemFont(ofSize: 14),
        color: .white,
        textAlignment: .center
    ) {
        didSet {
            subTitleLabel.font = subTitleLabelConfig.font
            subTitleLabel.textColor = subTitleLabelConfig.color
            subTitleLabel.textAlignment = subTitleLabelConfig.textAlignment
        }
    }

    public var spacingForTitleAndSubTitle: CGFloat = 30 {
        didSet {
            subTitleLabel.snp.updateConstraints {
                $0.bottom.equalTo(titleLabel.snp.bottom).offset(spacingForTitleAndSubTitle)
            }
        }
    }
    public var titleOffsetFromCenterY: CGFloat = UIScreen.main.bounds.width * 0.3 {
        didSet {
            titleLabel.snp.updateConstraints {
                $0.centerY.equalToSuperview().offset(titleOffsetFromCenterY)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        titleLabel = UILabel().then {
            $0.textAlignment = titleLabelConfig.textAlignment
            $0.textColor = titleLabelConfig.color
            $0.font = titleLabelConfig.font
        }
        subTitleLabel = UILabel().then {
            $0.textAlignment = titleLabelConfig.textAlignment
            $0.textColor = titleLabelConfig.color
            $0.font = titleLabelConfig.font
        }

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(titleOffsetFromCenterY)
        }
        subTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.bottom).offset(spacingForTitleAndSubTitle)
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    public func apply(
        imageURL: String?,
        title: String?,
        subTitle: String?
    ) {
        if let urlString = imageURL,
            let imageURL = URL(string: urlString) {
            UIHelper.loadImage(imageURL: imageURL, imageView: imageView)
        }
        if let title = title {
            titleLabel.text = title
        }
        if let subTitle = subTitle {
            subTitleLabel.text = subTitle
        }
    }
}
