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
        
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: insets.left)

        let rightConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: insets.right)

        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: insets.bottom)

        let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: insets.top)
        
        superview?.addConstraints([leftConstraint, rightConstraint, bottomConstraint, topConstraint])
    }

    public func ms_pinEdgesToSuperview(constraintParams: [(attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, constant: CGFloat)]) {
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        for constraintParam in constraintParams {
            let constraint = NSLayoutConstraint(item: self, attribute: constraintParam.attribute, relatedBy: constraintParam.relation, toItem: superview, attribute: constraintParam.attribute, multiplier: 1.0, constant: constraintParam.constant)
            constraints.append(constraint)
        }
        
        superview?.addConstraints(constraints)
    }
}
