//
//  ProductCollectionCell.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/13/24.
//

import UIKit

import SnapKit
import Then

class ProductCollectionCell: UICollectionViewCell {

    var vStackView: UIStackView!
    var imageContainerView: UIView!
    var productImageView: UIImageView!
    var couponLabelContainerView: UIView!
    var couponLabel: UILabel!

    var hStackView: UIStackView!
    var brandLabel: UILabel!
    var priceLabel: UILabel!
    var saleRateLabel: UILabel!

    required init?(coder: NSCoder) {
        fatalError()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        vStackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 3
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
            $0.backgroundColor = .systemIndigo.withAlphaComponent(0.9)
            $0.isHidden = true
        }
        couponLabel = UILabel().then {
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 11, weight: .regular)
            $0.text = "쿠폰"
        }
        brandLabel = UILabel().then {
            $0.textAlignment = .left
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 12)
        }
        priceLabel = UILabel().then {
            $0.textAlignment = .left
            $0.textColor = .label
            $0.font = .systemFont(ofSize: 16)
        }
        saleRateLabel = UILabel().then {
            $0.textAlignment = .left
            $0.textColor = .orange
            $0.font = .systemFont(ofSize: 12)
        }

        contentView.addSubview(vStackView)

        vStackView.addArrangedSubview(imageContainerView)
        imageContainerView.addSubview(productImageView)
        imageContainerView.addSubview(couponLabelContainerView)
        couponLabelContainerView.addSubview(couponLabel)
        vStackView.addVerticalSpacer(5)
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
            $0.width.equalTo(35)
            $0.height.equalTo(25)
            $0.left.bottom.equalToSuperview()
        }
        couponLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        couponLabelContainerView.isHidden = true
        brandLabel.text = nil
        priceLabel.text = nil
        saleRateLabel.text = nil
    }

    func apply(
        imageURL: String?,
        brandName: String,
        price: Int,
        saleRate: Int,
        hasCoupone: Bool
    ) {
        if let urlString = imageURL,
            let imageURL = URL(string: urlString) {
            UIHelper.loadImage(imageURL: imageURL, imageView: productImageView)
        }
        brandLabel.text = brandName
        priceLabel.text = "\(price)원"
        saleRateLabel.text = "\(saleRate)%"
        couponLabelContainerView.isHidden = !hasCoupone
    }
}
