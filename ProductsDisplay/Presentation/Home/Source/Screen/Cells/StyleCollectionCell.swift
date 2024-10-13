//
//  StyleCollectionCell.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/13/24.
//

import UIKit

import SnapKit
import Then

class StyleCollectionCell: UICollectionViewCell {

    var imageView: UIImageView!

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
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
