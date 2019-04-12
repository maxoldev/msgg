//
//  PlayerControlButton.swift
//  MSGG
//
//  Created by Maxim Solovyov on 10/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

class PlayerControlButton: UIButton {

    let unfocusedAlpha: CGFloat = 0.7
    let unfocusedScale: CGFloat = 0.8
    
    override func didMoveToSuperview() {
        guard superview != nil else {
            return
        }
        self.alpha = unfocusedAlpha
        self.transform = CGAffineTransform(scaleX: unfocusedScale, y: unfocusedScale)
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        let alpha: CGFloat = context.nextFocusedView == self ? 1 : unfocusedAlpha
        let scale: CGFloat = context.nextFocusedView == self ? 1 : unfocusedScale
        coordinator.addCoordinatedAnimations({
            self.alpha = alpha
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
}
