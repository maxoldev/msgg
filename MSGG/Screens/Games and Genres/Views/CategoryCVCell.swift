//
//  CategoryCVCell.swift
//  MSGG
//
//  Created by Maxim Solovyov on 13/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit
import SDWebImage

class CategoryCVCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var streamsLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var bottomSpacingCs: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverImageView.adjustsImageWhenAncestorFocused = true
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
        bottomSpacingCs.constant = context.nextFocusedView == self ? -30 : 0
        coordinator.addCoordinatedAnimations({
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
