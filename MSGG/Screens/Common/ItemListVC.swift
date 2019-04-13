//
//  ItemListVC.swift
//  MSGG
//
//  Created by Maxim Solovyov on 13/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

class ItemListVC<T>: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var fadeView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var items = [T]()

    fileprivate var prevFocusedView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCellAndViews()
        loadData()
    }
    
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 80)
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = horizontalSpacing
        layout.minimumLineSpacing = verticalSpacing
    }
    
    func registerCellAndViews() {
        collectionView.register(UINib(nibName: String(describing: StreamListHeaderReusableView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: StreamListHeaderReusableView.self))
    }
    
    var isLoading = false {
        didSet {
            if isLoading {
                fadeView.isHidden = false
                activityIndicator.startAnimating()
            } else {
                fadeView.isHidden = true
                activityIndicator.stopAnimating()
            }
        }
    }
    
    func loadData() {
        fatalError("Must me overridden")
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        if prevFocusedView != nil {
            setNeedsFocusUpdate()
            return false
        }
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView is UIButton {
            prevFocusedView = context.previouslyFocusedView  // save last focused cell to return to it after the button
        }
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        if let prevFocusedView = prevFocusedView {
            self.prevFocusedView = nil
            return [prevFocusedView]
        }
        return [collectionView]
    }

    var itemSize: CGSize {
        return CGSize(width: 548, height: 340)
    }
    
    var horizontalSpacing: CGFloat {
        return 48
    }
    
    var verticalSpacing: CGFloat {
        return 100
    }

    //MARK: - Actions

    @objc func onReload(_ sender: Any) {
        prevFocusedView = nil
        loadData()
    }

    //MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Must me overridden")
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: StreamListHeaderReusableView.self), for: indexPath) as! StreamListHeaderReusableView
        headerView.reloadButton.addTarget(self, action: #selector(onReload), for: .primaryActionTriggered)
        return headerView
    }

    //MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fatalError("Must me overridden")
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
}
