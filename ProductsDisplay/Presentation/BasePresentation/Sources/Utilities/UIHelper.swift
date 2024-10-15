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
        imageView: ImageDisplayingView
    ) {
        NukeExtensions.loadImage(
            with: imageURL,
            options: ImageLoadingOptions(
                placeholder: UIImage(systemName: "swift"),
                transition: .fadeIn(duration: 0.5),
                failureImage: UIImage(systemName: "exclamationmark.triangle"),
                failureImageTransition: .none
            ),
            into: imageView
        )
    }
}

extension UIButton: Nuke_ImageDisplaying {
    public func nuke_display(image: UIImage?, data: Data?) {
        setImage(
            image: image?.resize(targetSize: .init(width: 20, height: 20)),
            padding: 5
        )
    }
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage? {
        let newRect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newRect.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.interpolationQuality = .high
        draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
