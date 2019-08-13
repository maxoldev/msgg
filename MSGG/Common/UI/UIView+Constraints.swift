//
//  UIView+Constraints.swift
//  TelegramCharts
//
//  Created by Maxim Solovyov on 21/03/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

extension UIView {
    
    public func ms_pinEdgesToSuperview(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: insets.left),
                           trailingAnchor.constraint(equalTo: superview!.trailingAnchor, constant: insets.right),
                           topAnchor.constraint(equalTo: superview!.topAnchor, constant: insets.top),
                           bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: insets.bottom)]

        NSLayoutConstraint.activate(constraints)
    }

    public func ms_pinEdgesToSuperview(constraintParams: [(attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, constant: CGFloat)]) {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = constraintParams.map { (attribute, relation, constant) in
            NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relation, toItem: superview, attribute: attribute, multiplier: 1.0, constant: constant)
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}
