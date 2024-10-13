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
        imageView: UIImageView
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
