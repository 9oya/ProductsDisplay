//
//  PageFooterCollectionReusableView.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/17/24.
//

import UIKit

import Then
import SnapKit
import RxSwift

public class PageFooterCollectionReusableView: UICollectionReusableView {

    public var disposeBag = DisposeBag()
    public var pageNumberContainerView: UIView!
    public var pageNumberLabel: UILabel!

    public var pageNumberLabelText: String? {
        didSet {
            pageNumberLabel.text = pageNumberLabelText
        }
    }

    public var pageNumberLabelFont: UIFont = .systemFont(ofSize: 12) {
        didSet {
            pageNumberLabel.font = pageNumberLabelFont
        }
    }

    public var pageNumberLabelTextColor: UIColor = .white {
        didSet {
            pageNumberLabel.textColor = pageNumberLabelTextColor
        }
    }

    public var pageNumberContainerBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.5) {
        didSet {
            pageNumberContainerView.backgroundColor = pageNumberContainerBackgroundColor
        }
    }

    public var pageNumberContainerSize: CGSize = .init(width: 70, height: 25) {
        didSet {
            pageNumberContainerView.snp.updateConstraints {
                $0.width.equalTo(pageNumberContainerSize.width)
                $0.height.equalTo(pageNumberContainerSize.height)
                $0.top.equalToSuperview().offset(-pageNumberContainerSize.height)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        pageNumberContainerView = UIView().then {
            $0.backgroundColor = pageNumberContainerBackgroundColor
        }
        pageNumberLabel = UILabel().then {
            $0.textColor = pageNumberLabelTextColor
            $0.font = pageNumberLabelFont
        }
        addSubview(pageNumberContainerView)
        pageNumberContainerView.addSubview(pageNumberLabel)
        pageNumberContainerView.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.width.equalTo(pageNumberContainerSize.width)
            $0.height.equalTo(pageNumberContainerSize.height)
            $0.top.equalToSuperview().offset(-pageNumberContainerSize.height)
        }
        pageNumberLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        pageNumberLabel.text = nil
    }
}

