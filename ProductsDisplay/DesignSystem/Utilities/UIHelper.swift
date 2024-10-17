//
//  UIHelper.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/13/24.
//

import Foundation
import UIKit

import NukeExtensions

class UIHelper {

    @MainActor
    static func loadImage(
        imageURL: URL,
        imageView: ImageDisplayingView,
        placeholder: UIImage? = UIImage(systemName: "scribble"),
        failureImage: UIImage? = UIImage(systemName: "exclamationmark.triangle"),
        transition: ImageLoadingOptions.Transition? = .fadeIn(duration: 0.5),
        imageSize: CGSize? = nil
    ) {
        NukeExtensions.loadImage(
            with: imageURL,
            options: ImageLoadingOptions(
                placeholder: placeholder,
                transition: transition,
                failureImage: failureImage,
                failureImageTransition: .none
            ),
            into: imageView) { result in
                if let imageSize = imageSize,
                    case .success(let response) = result {
                    if let imageView = imageView as? UIButton {
                        imageView.setImage(
                            image: response.image.resized(to: imageSize),
                            renderingMode: .automatic,
                            padding: 5
                        )
                    }
                }
            }
    }
}

extension UIButton: Nuke_ImageDisplaying {
    public func nuke_display(image: UIImage?, data: Data?) {
        setImage(
            image: image,
            renderingMode: .automatic
        )
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
