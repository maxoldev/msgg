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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.adjustsImageWhenAncestorFocused = true
    }
    
    func setup(streamer: String, title: String, viewers: Int, thumbURL: String) {
        streamerLabel.text = streamer
        titleLabel.text = title
        viewersLabel.text = "\(viewers)"
        thumbImageView.sd_setImage(with: URL(string: thumbURL), placeholderImage: nil, options: [SDWebImageOptions.fromLoaderOnly, SDWebImageOptions.retryFailed], context: nil)
        
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        bottomSpacingCs.constant = context.nextFocusedView == self ? -20 : 0
        coordinator.addCoordinatedAnimations({
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
