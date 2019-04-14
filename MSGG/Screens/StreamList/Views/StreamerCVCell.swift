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
    @IBOutlet weak var bottomSpacingCs: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.adjustsImageWhenAncestorFocused = true
    }
    
    func setup(streamer: String, avatarURL: String) {
        streamerLabel.text = streamer
        thumbImageView.sd_setImage(with: URL(string: avatarURL),
                                   placeholderImage: UIImage(named: "gg-logo"),
                                   options: [SDWebImageOptions.retryFailed])
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        bottomSpacingCs.constant = context.nextFocusedView == self ? -20 : 0
        coordinator.addCoordinatedAnimations({
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
