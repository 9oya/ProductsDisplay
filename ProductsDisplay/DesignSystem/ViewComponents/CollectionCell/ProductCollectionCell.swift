//
//  ProductCollectionCell.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/13/24.
//

import UIKit

import SnapKit
import Then

public class ProductCollectionCell: UICollectionViewCell {

    public var vStackView: UIStackView!
    public var imageContainerView: UIView!
    public var productImageView: UIImageView!
    public var couponLabelContainerView: UIView!
    public var couponLabel: UILabel!

    public var hStackView: UIStackView!
    public var brandLabel: UILabel!
    public var priceLabel: UILabel!
    public var saleRateLabel: UILabel!

    public var brandLabelConfig: PDLabelConfig = .init(
        font: .systemFont(ofSize: 12, weight: .regular),
        color: .gray,
        textAlignment: .left
    ) {
        didSet {
            brandLabel.font = brandLabelConfig.font
            brandLabel.textColor = brandLabelConfig.color
            brandLabel.textAlignment = brandLabelConfig.textAlignment
        }
    }

    public var priceLabelConfig: PDLabelConfig = .init(
        font: .systemFont(ofSize: 14, weight: .regular),
        color: .label,
        textAlignment: .left
    ) {
        didSet {
            priceLabel.font = priceLabelConfig.font
            priceLabel.textColor = priceLabelConfig.color
            priceLabel.textAlignment = priceLabelConfig.textAlignment
        }
    }

    public var saleRateLabelConfig: PDLabelConfig = .init(
        font: .systemFont(ofSize: 12, weight: .medium),
        color: .orange,
        textAlignment: .left
    ) {
        didSet {
            saleRateLabel.font = saleRateLabelConfig.font
            saleRateLabel.textColor = saleRateLabelConfig.color
            saleRateLabel.textAlignment = saleRateLabelConfig.textAlignment
        }
    }

    public var couponLabelConfig: PDLabelConfig = .init(
        font: .systemFont(ofSize: 11, weight: .regular),
        color: .white,
        textAlignment: .center
    ) {
        didSet {
            couponLabel.font = couponLabelConfig.font
            couponLabel.textColor = couponLabelConfig.color
            couponLabel.textAlignment = couponLabelConfig.textAlignment
        }
    }

    public var couponLabelName: String = "쿠폰" {
        didSet {
            couponLabel.text = couponLabelName
        }
    }

    public var couponLabelBackgroundColor: UIColor = .systemIndigo.withAlphaComponent(0.9) {
        didSet {
            couponLabelContainerView.backgroundColor = couponLabelBackgroundColor
        }
    }

    public var couponLabelSize: CGSize = .init(width: 35, height: 25) {
        didSet {
            couponLabelContainerView.snp.updateConstraints {
                $0.width.equalTo(couponLabelSize.width)
                $0.height.equalTo(couponLabelSize.height)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        vStackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 0
            $0.alignment = .leading
        }
        hStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
        }
        imageContainerView = UIView().then {
            $0.backgroundColor = .systemBackground
        }
        productImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        couponLabelContainerView = UIView().then {
            $0.backgroundColor = couponLabelBackgroundColor
            $0.isHidden = true
        }
        couponLabel = UILabel().then {
            $0.textAlignment = couponLabelConfig.textAlignment
            $0.textColor = couponLabelConfig.color
            $0.font = couponLabelConfig.font
            $0.text = couponLabelName
        }
        brandLabel = UILabel().then {
            $0.textAlignment = brandLabelConfig.textAlignment
            $0.textColor = brandLabelConfig.color
            $0.font = brandLabelConfig.font
        }
        priceLabel = UILabel().then {
            $0.textAlignment = priceLabelConfig.textAlignment
            $0.textColor = priceLabelConfig.color
            $0.font = priceLabelConfig.font
        }
        saleRateLabel = UILabel().then {
            $0.textAlignment = saleRateLabelConfig.textAlignment
            $0.textColor = saleRateLabelConfig.color
            $0.font = saleRateLabelConfig.font
        }

        contentView.addSubview(vStackView)

        vStackView.addArrangedSubview(imageContainerView)
        imageContainerView.addSubview(productImageView)
        imageContainerView.addSubview(couponLabelContainerView)
        couponLabelContainerView.addSubview(couponLabel)
        vStackView.addVerticalSpacer(10)
        vStackView.addArrangedSubview(brandLabel)

        hStackView.addArrangedSubview(priceLabel)
        hStackView.addHorizontalSpacer()
        hStackView.addArrangedSubview(saleRateLabel)
        vStackView.addArrangedSubview(hStackView)
        vStackView.addVerticalSpacer()

        vStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imageContainerView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(contentView.frame.width * 1.3)
        }
        productImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        hStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        couponLabelContainerView.snp.makeConstraints {
            $0.width.equalTo(couponLabelSize.width)
            $0.height.equalTo(couponLabelSize.height)
            $0.left.bottom.equalToSuperview()
        }
        couponLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        couponLabelContainerView.isHidden = true
        brandLabel.text = nil
        priceLabel.text = nil
        saleRateLabel.text = nil
    }

    public func apply(
        imageURL: String?,
        brandName: String,
        price: Int,
        priceLabelSuffix: String = "원",
        saleRate: Int,
        saleRateLabelSuffix: String = "%",
        hasCoupone: Bool
    ) {
        if let urlString = imageURL,
            let imageURL = URL(string: urlString) {
            UIHelper.loadImage(imageURL: imageURL, imageView: productImageView)
        }
        brandLabel.text = brandName
        let numberFormatter = NumberFormatter().then {
            $0.numberStyle = .decimal
            $0.maximumFractionDigits = 0
        }
        priceLabel.text = "\(numberFormatter.string(from: NSNumber(value: price))!)\(priceLabelSuffix)"
        saleRateLabel.text = "\(saleRate)\(saleRateLabelSuffix)"
        couponLabelContainerView.isHidden = !hasCoupone
    }
}
