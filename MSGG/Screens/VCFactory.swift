//
//  VCFactory.swift
//  MSGG
//
//  Created by Maxim Solovyov on 10/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

protocol VCFactory {
    
    func create<T>(_ e: VCEnum) -> T where T: UIViewController
}

class VCFactoryImpl: VCFactory {
    
    func create<T>(_ e: VCEnum) -> T where T: UIViewController{
        return e.vc() as T
    }
}

enum VCEnum: String {
    
    case streamList
    case categoryList
    case stream
    
    fileprivate var storyboardName: String {
        switch self {
        case .stream:
            return "Main"
        default:
            return ""
        }
    }
    
    fileprivate var nibName: String {
        switch self {
        case .streamList, .categoryList:
            return "ItemListVC"
        default:
            return ""
        }
    }

    fileprivate var vcName: String {
        return self.rawValue
    }
    
    fileprivate func vc<T>() -> T where T: UIViewController {
        if !storyboardName.isEmpty {
            return storyboard.instantiateViewController(withIdentifier: vcName) as! T
        } else {
            return fromNib(nibName: nibName)
        }
    }
    
    fileprivate var storyboard: UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: nil)
    }
    
    fileprivate func fromNib<T>(nibName: String) -> T where T: UIViewController  {
        return T(nibName: "ItemListVC", bundle: nil)
    }
}
