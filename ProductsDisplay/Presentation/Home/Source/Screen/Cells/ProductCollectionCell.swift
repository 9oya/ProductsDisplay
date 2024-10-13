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

    var imageView: UIImageView!
    var containerView: UIView!
    var label: UILabel!

    required init?(coder: NSCoder) {
        fatalError()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .green

        imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        containerView = UIView().then {
            $0.backgroundColor = .white
        }
        label = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = .black
            $0.text = "Hello"
        }
        contentView.addSubview(imageView)
        contentView.addSubview(containerView)
        containerView.addSubview(label)

        containerView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview()
        }
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        imageView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.bottom.equalTo(containerView.snp.top)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    func apply(imageURL: String?) {
        if let urlString = imageURL,
            let imageURL = URL(string: urlString) {
            UIHelper.loadImage(imageURL: imageURL, imageView: imageView)
        }
    }
}
