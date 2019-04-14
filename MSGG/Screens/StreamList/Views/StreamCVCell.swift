//
//  StreamCVCell.swift
//  MSGG
//
//  Created by Maxim Solovyov on 12/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit
import SDWebImage
import MarqueeLabel

class StreamCVCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: MarqueeLabel!
    @IBOutlet weak var streamerLabel: UILabel!
    @IBOutlet weak var viewersIcon: UIImageView!
    @IBOutlet weak var viewersLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var warningImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.adjustsImageWhenAncestorFocused = true
        [titleLabel, streamerLabel, viewersIcon, viewersLabel].forEach({ $0.alpha = AppAppearance.unfocusedAlpha })
    }
    
    func setup(streamer: String, title: String, viewers: Int, previewURL: String, posterURL: String, warning: Bool) {
        streamerLabel.text = streamer
        titleLabel.text = title
        viewersLabel.text = "\(viewers)"
        thumbImageView.sd_setImage(with: URL(string: previewURL),
                                   placeholderImage: UIImage(named: "gg-logo"),
                                   options: [SDWebImageOptions.fromLoaderOnly, SDWebImageOptions.retryFailed])
        { [weak self] (image, error, _, _) in
            guard error != nil, let self = self else {
                return
            }
            self.thumbImageView.sd_setImage(with: URL(string: posterURL),
                                       placeholderImage: UIImage(named: "gg-logo"),
                                       options: [SDWebImageOptions.fromLoaderOnly])
        }
        warningImageView.isHidden = !warning
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        let isFocused = context.nextFocusedView == self
        titleLabel.labelize = isFocused ? false : true

        coordinator.addCoordinatedAnimations({
            self.titleLabel.alpha = isFocused ? 1 : AppAppearance.unfocusedAlpha
            self.streamerLabel.alpha = isFocused ? 1 : AppAppearance.unfocusedAlpha
            self.viewersIcon.alpha = isFocused ? 1 : AppAppearance.unfocusedAlpha
            self.viewersLabel.alpha = isFocused ? 1 : AppAppearance.unfocusedAlpha
        }, completion: nil)
    }
}
