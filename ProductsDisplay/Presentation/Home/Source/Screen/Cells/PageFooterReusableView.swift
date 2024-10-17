//
//  PageFooterReusableView.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/17/24.
//

import UIKit

import Then
import SnapKit
import RxSwift

class PageFooterReusableView: UICollectionReusableView {

    var disposeBag = DisposeBag()
    var pageNumberContainerView: UIView!
    var pageNumberLabel: UILabel!

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        pageNumberContainerView = UIView().then {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
        pageNumberLabel = UILabel().then {
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 12)
        }
        addSubview(pageNumberContainerView)
        pageNumberContainerView.addSubview(pageNumberLabel)
        pageNumberContainerView.snp.makeConstraints {
            $0.right.top.equalToSuperview()
            $0.top.equalToSuperview().offset(-25)
            $0.height.equalTo(25)
            $0.width.equalTo(70)
        }
        pageNumberLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func apply() {
    }
}

