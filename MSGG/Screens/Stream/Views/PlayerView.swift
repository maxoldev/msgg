//
//  PlayerView.swift
//  MSGG
//
//  Created by Maxim Solovyov on 10/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerView: UIView {
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

//    var player: AVPlayer! {
//        get {
//            return playerLayer.player
//        }
//
//        set {
//            playerLayer.player = newValue
//        }
//    }
    let player = AVPlayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playerLayer.player = player
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playerLayer.player = player
    }
}
