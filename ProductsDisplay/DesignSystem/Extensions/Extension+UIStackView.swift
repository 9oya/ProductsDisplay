//
//  Extension+UIStackView.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/16/24.
//

import UIKit

extension UIStackView {

    func addHorizontalSpacer(_ width: CGFloat? = nil) {
        let spacer = UIView()
        addArrangedSubview(spacer)
        if let width = width {
            spacer.snp.makeConstraints {
                $0.width.equalTo(width)
            }
        } else {
            spacer.isUserInteractionEnabled = false
            spacer.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
            spacer.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        }
    }

    func addVerticalSpacer(_ height: CGFloat? = nil) {
        let spacer = UIView()
        addArrangedSubview(spacer)
        if let height = height {
            spacer.snp.makeConstraints {
                $0.height.equalTo(height)
            }
        } else {
            spacer.isUserInteractionEnabled = false
            spacer.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
            spacer.setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)
        }
    }
}
