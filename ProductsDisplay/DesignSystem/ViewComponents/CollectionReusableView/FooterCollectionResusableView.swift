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

public class FooterCollectionResusableView: UICollectionReusableView {

    public enum FooterType: String {
        case refresh = "REFRESH"
        case more = "MORE"

        func toTitle() -> String {
            switch self {
            case .refresh:
                return "새로운 추천"
            case .more:
                return "더보기"
            }
        }
    }

    public struct ButtonBorder {
        let radius: CGFloat
        let color: UIColor
        let width: CGFloat

        init(radius: CGFloat, color: UIColor, width: CGFloat) {
            self.radius = radius
            self.color = color
            self.width = width
        }
    }

    public var disposeBag = DisposeBag()
    public var button: TouchAnimationButton!

    public var imageSize: CGSize = .init(width: 20, height: 20) {
        didSet {
            button.snp.updateConstraints {
                $0.width.equalTo(imageSize.width)
                $0.height.equalTo(imageSize.height)
            }
        }
    }

    public var buttonTitleFont: UIFont = .systemFont(ofSize: 15, weight: .bold) {
        didSet {
            button.setTitle(
                attrString: button.configuration?.attributedTitle ?? "",
                font: buttonTitleFont,
                color: buttonTitleColor
            )
        }
    }

    public var buttonTitleColor: UIColor = .label {
        didSet {
            button.setTitle(
                attrString: button.configuration?.attributedTitle ?? "",
                font: buttonTitleFont,
                color: buttonTitleColor
            )
        }
    }

    public var buttonBorder: ButtonBorder = .init(
        radius: 30,
        color: .systemGray5,
        width: 1
    ) {
        didSet {
            button.setBorder(
                radius: buttonBorder.radius,
                color: buttonBorder.color,
                width: buttonBorder.width
            )
        }
    }

    public var buttonTouchType: TouchAnimationType = .scale {
        didSet {
            button.touchType = buttonTouchType
        }
    }

    public var buttonEdgeInsets: UIEdgeInsets = .init(top: 15, left: 15, bottom: 15, right: 15) {
        didSet {
            button.snp.updateConstraints  {
                $0.top.equalToSuperview().inset(buttonEdgeInsets.top)
                $0.left.equalToSuperview().inset(buttonEdgeInsets.left)
                $0.bottom.equalToSuperview().inset(buttonEdgeInsets.bottom)
                $0.right.equalToSuperview().inset(buttonEdgeInsets.right)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        button = TouchAnimationButton().then {
            $0.setBorder(
                radius: buttonBorder.radius,
                color: buttonBorder.color,
                width: buttonBorder.width
            )
            $0.touchType = buttonTouchType
        }
        addSubview(button)
        button.snp.makeConstraints {
            $0.top.equalToSuperview().inset(buttonEdgeInsets.top)
            $0.left.equalToSuperview().inset(buttonEdgeInsets.left)
            $0.bottom.equalToSuperview().inset(buttonEdgeInsets.bottom)
            $0.right.equalToSuperview().inset(buttonEdgeInsets.right)
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        button.setImage(image: nil, padding: 0)
    }

    public func apply(
        footerType: FooterCollectionResusableView.FooterType,
        iconURL: String?
    ) {
        if let iconURL = iconURL,
            let imgURL = URL(string: iconURL) {
            UIHelper.loadImage(
                imageURL: imgURL,
                imageView: button,
                imageSize: imageSize
            )
        }
        button.setTitle(
            text: footerType.toTitle(),
            font: buttonTitleFont,
            color: buttonTitleColor
        )
    }
}
