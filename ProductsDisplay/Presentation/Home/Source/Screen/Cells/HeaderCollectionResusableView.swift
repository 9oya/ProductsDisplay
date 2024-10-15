//
//  HeaderCollectionResusableView.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/13/24.
//

import UIKit

class HeaderCollectionResusableView: UICollectionReusableView {
    var label: UILabel!

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        label = UILabel().then {
            $0.text = "Header"
            $0.textAlignment = .center
            $0.textColor = .black
        }
        addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
