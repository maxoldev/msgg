//
//  HintView.swift
//  MSGG
//
//  Created by Maxim Solovyov on 17/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

class HintView: UIView {

    fileprivate(set) var label: UILabel!
    fileprivate var autoHideTimer: Timer?

    var animationDuration: TimeInterval = 0.3
    var onHideCompletion: () -> () = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        label = createLabel()
        addSubview(label)
        label.ms_pinEdgesToSuperview(insets: UIEdgeInsets(top: 40, left: 40, bottom: -40, right: -40))
        isHidden = true
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview == nil && autoHideTimer != nil {
            autoHideTimer?.invalidate()
        }
    }
    
    func show(animated: Bool, autoHideTime: TimeInterval? = nil) {
        isHidden = false
        alpha = 0
        if animated {
            UIView.animate(withDuration: animationDuration, animations: {
                self.alpha = 1
            }) { (_) in
                self.isHidden = false
            }
        } else {
            alpha = 1
            isHidden = false
        }
        
        if let autoHideTime = autoHideTime {
            autoHideTimer = Timer.scheduledTimer(withTimeInterval: autoHideTime, repeats: false, block: { (timer) in
                self.hide(animated: true)
                timer.invalidate()
                self.autoHideTimer = nil
            })
        }
    }
    
    func hide(animated: Bool) {
        if animated {
            UIView.animate(withDuration: animationDuration, animations: {
                self.alpha = 0
            }) { (_) in
                self.isHidden = true
                self.onHideCompletion()
            }
        } else {
            alpha = 0
            isHidden = true
            onHideCompletion()
        }
    }
    
    fileprivate func createLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.shadowColor = UIColor.black
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
