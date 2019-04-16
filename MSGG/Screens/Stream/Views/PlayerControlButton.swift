//
//  PlayerControlButton.swift
//  MSGG
//
//  Created by Maxim Solovyov on 10/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

@IBDesignable class PlayerControlButton: UIButton {

    @IBInspectable var isRoundButton: Bool = true
    @IBInspectable var customCornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = customCornerRadius
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isRoundButton {
            layer.cornerRadius = bounds.height / 2
        }
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        let bgColor = context.nextFocusedView == self ? UIColor(named: "color-button-bg") : UIColor.clear
        coordinator.addCoordinatedAnimations({
            self.backgroundColor = bgColor
        }, completion: nil)
    }
}
