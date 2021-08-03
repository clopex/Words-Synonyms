//
//  UILabel.swift
//  W&S
//
//  Created by Adis Mulabdic on 30.07.2021..
//

import UIKit

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 7.0
    @IBInspectable var bottomInset: CGFloat = 7.0
    @IBInspectable var leftInset: CGFloat = 1.0
    @IBInspectable var rightInset: CGFloat = 1.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
