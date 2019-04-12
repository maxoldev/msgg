//
//  ClassicStreamCVCell.swift
//  MSGG
//
//  Created by Maxim Solovyov on 29/10/2018.
//  Copyright © 2018 MaximSolovyov. All rights reserved.
//

import UIKit
import SDWebImage

class ClassicStreamCVCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var streamerLabel: UILabel!
    @IBOutlet weak var viewersLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(streamer: String, title: String, viewers: Int, thumbURL: String) {
        streamerLabel.text = streamer
        titleLabel.text = title
        viewersLabel.text = "\(viewers)"
        thumbImageView.sd_setImage(with: URL(string: thumbURL), placeholderImage: nil, options: [SDWebImageOptions.fromLoaderOnly, SDWebImageOptions.retryFailed], context: nil)

    }
}
