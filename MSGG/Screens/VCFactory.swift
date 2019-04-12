//
//  VCFactory.swift
//  MSGG
//
//  Created by Maxim Solovyov on 10/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

protocol VCFactory {
    
    func create<T: UIViewController>(_ e: VCEnum) -> T
}

class VCFactoryImpl: VCFactory {
    
    func create<T: UIViewController>(_ e: VCEnum) -> T {
        return e.vc as! T
    }
    
    func create<T: UITableViewController>(_ e: VCEnum) -> T {
        return e.tvc as! T
    }
}

enum VCEnum {
    
    case stream
    
    fileprivate var storyboardName: String {
        switch self {
        case .stream:
            return "Main"
        }
    }
    
    fileprivate var vcName: String {
        return "\(self)"
    }
    
    fileprivate var vc: UIViewController {
        return storyboard.instantiateViewController(withIdentifier: vcName)
    }
    
    fileprivate var tvc: UITableViewController {
        return storyboard.instantiateViewController(withIdentifier: vcName) as! UITableViewController
    }
    
    fileprivate var storyboard: UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: nil)
    }
}
