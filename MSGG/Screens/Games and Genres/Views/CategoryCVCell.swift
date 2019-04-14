//
//  CategoryCVCell.swift
//  MSGG
//
//  Created by Maxim Solovyov on 13/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit
import SDWebImage
import MarqueeLabel

class CategoryCVCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: MarqueeLabel!
    @IBOutlet weak var streamsLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverImageView.adjustsImageWhenAncestorFocused = true
        [titleLabel, streamsLabel].forEach({ $0.alpha = AppAppearance.unfocusedAlpha })
    }
    
    func setup(title: String, streams: Int, thumbURL: String) {
        titleLabel.text = title
        streamsLabel.text = "\(streams) " + NSLocalizedString("streams", comment: "")
        coverImageView.sd_setImage(with: URL(string: thumbURL),
                                   placeholderImage: nil,
                                   options: [SDWebImageOptions.retryFailed],
                                   context: nil)
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        let isFocused = context.nextFocusedView == self
        titleLabel.labelize = isFocused ? false : true
        coordinator.addCoordinatedAnimations({
            self.titleLabel.alpha = isFocused ? 1 : AppAppearance.unfocusedAlpha
            self.streamsLabel.alpha = isFocused ? 1 : AppAppearance.unfocusedAlpha
        }, completion: nil)
    }
}
