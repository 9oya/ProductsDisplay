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
        button.setImage(image: nil, padding: 0)
    }

    func apply(footerType: FooterType, iconURL: String?) {
        var title = ""
        switch footerType {
        case .more:
            title = "더보기"
        case .refresh:
            title = "새로운 추천"
        }
        if let iconURL = iconURL, 
            let imgURL = URL(string: iconURL) {
            UIHelper.loadImage(
                imageURL: imgURL,
                imageView: button,
                imageSize: .init(width: 20, height: 20)
            )
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
