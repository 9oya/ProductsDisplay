//
//  HeaderCollectionResusableView.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/13/24.
//

import UIKit

import Then
import SnapKit

class HeaderCollectionResusableView: UICollectionReusableView {
    var hStackView: UIStackView!
    var titleLabel: UILabel!
    var iconImageView: UIImageView!
    var button: UIButton!

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        hStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .center
        }

        titleLabel = UILabel().then {
            $0.textAlignment = .left
            $0.textColor = .label
            $0.font = .systemFont(ofSize: 20, weight: .bold)
            $0.numberOfLines = 0
        }
        iconImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
        }
        button = UIButton().then {
            $0.setTitle(
                text: "전체",
                font: .systemFont(ofSize: 15, weight: .light),
                color: .systemGray,
                titleAlignment: .trailing
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
            $0.width.height.equalTo(20)
        }
        button.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
            $0.width.height.equalTo(60)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        iconImageView.image = nil
        button.isHidden = true
    }

    func apply(title: String, iconURL: String?, linkURL: String?) {
        titleLabel.text = title
        if let iconURL = iconURL, let imgURL = URL(string: iconURL) {
            UIHelper.loadImage(imageURL: imgURL, imageView: iconImageView)
        }
        button.isHidden = linkURL == nil
    }
}
