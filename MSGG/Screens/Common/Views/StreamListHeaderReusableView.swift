//
//  StreamListHeaderReusableView.swift
//  MSGG
//
//  Created by Maxim Solovyov on 13/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

class StreamListHeaderReusableView: UICollectionReusableView {
    
    @IBOutlet weak var reloadButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let focusGuide = UIFocusGuide()
        addLayoutGuide(focusGuide)
        focusGuide.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        focusGuide.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        focusGuide.topAnchor.constraint(equalTo: topAnchor).isActive = true
        focusGuide.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        focusGuide.preferredFocusEnvironments = [reloadButton]
    }
}
