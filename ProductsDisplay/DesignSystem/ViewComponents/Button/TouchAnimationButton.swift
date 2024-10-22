//
//  PDTouchAnimationButton.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/17/24.
//

import UIKit

public enum TouchAnimationType {
    case background
    case scale
    case title
    case attrTitle(begin: NSAttributedString, end: NSAttributedString)
}

public class TouchAnimationButton: UIButton {

    public var touchType: TouchAnimationType = .background
    public var touchBeganColor: UIColor = .black.withAlphaComponent(0.2)
    public var touchEndedColor: UIColor = .clear

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(touchDragExit), for: .touchDragExit)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func touchDragExit() {
        cancelAnimation(touchType: self.touchType, touchEndedColor: self.touchEndedColor)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        switch self.touchType {
        case .background:
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = self.touchBeganColor
            }
        case .scale:
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        case .title:
            UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve) {
                self.setTitleColor(self.touchBeganColor, for: .normal)
            }
        case let .attrTitle(begin, _):
            UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve) {
                self.setAttributedTitle(begin, for: .normal)
            }
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        switch self.touchType {
        case .background:
            UIView.animate(withDuration: 0.2, delay: 0.2) {
                self.backgroundColor = self.touchEndedColor
            }
        case .scale:
            UIView.animate(withDuration: 0.1, delay: 0.1) {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        case .title:
            UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) {
                self.setTitleColor(self.touchEndedColor, for: .normal)
            }
        case let .attrTitle(_, end):
            UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) {
                self.setAttributedTitle(end, for: .normal)
            }
        }
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        cancelAnimation(touchType: self.touchType, touchEndedColor: self.touchEndedColor)
    }

}

extension TouchAnimationButton {

    private func cancelAnimation(touchType: TouchAnimationType, touchEndedColor: UIColor) {
        UIView.animate(withDuration: 0.2) {
            switch touchType {
            case .background:
                self.backgroundColor = touchEndedColor
            case .scale:
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            case .title:
                UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) {
                    self.setTitleColor(touchEndedColor, for: .normal)
                }
            case let .attrTitle(_, end):
                self.setAttributedTitle(end, for: .normal)
            }
        }
    }
}
