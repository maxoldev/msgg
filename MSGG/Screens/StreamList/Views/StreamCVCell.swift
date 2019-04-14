//
//  StreamCVCell.swift
//  MSGG
//
//  Created by Maxim Solovyov on 12/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit
import SDWebImage

class StreamCVCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var streamerLabel: UILabel!
    @IBOutlet weak var viewersLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var bottomSpacingCs: NSLayoutConstraint!
    @IBOutlet weak var warningImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.adjustsImageWhenAncestorFocused = true
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
        bottomSpacingCs.constant = context.nextFocusedView == self ? -20 : 0
        coordinator.addCoordinatedAnimations({
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
