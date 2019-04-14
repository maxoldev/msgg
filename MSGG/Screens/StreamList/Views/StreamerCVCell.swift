//
//  StreamerCVCell.swift
//  MSGG
//
//  Created by Maxim Solovyov on 12/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit
import SDWebImage

class StreamerCVCell: UICollectionViewCell {
    
    @IBOutlet weak var streamerLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.adjustsImageWhenAncestorFocused = true
        [streamerLabel].forEach({ $0.alpha = AppAppearance.unfocusedAlpha })
    }
    
    func setup(streamer: String, avatarURL: String) {
        streamerLabel.text = streamer
        thumbImageView.sd_setImage(with: URL(string: avatarURL),
                                   placeholderImage: UIImage(named: "avatar"),
                                   options: [SDWebImageOptions.retryFailed])
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        let isFocused = context.nextFocusedView == self
        coordinator.addCoordinatedAnimations({
            self.streamerLabel.alpha = isFocused ? 1 : AppAppearance.unfocusedAlpha
        }, completion: nil)
    }
}
