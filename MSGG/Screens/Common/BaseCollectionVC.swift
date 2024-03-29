//
//  BaseCollectionVC.swift
//  MSGG
//
//  Created by Maxim Solovyov on 14/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

class BaseCollectionVC: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var fadeView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var prevFocusedView: UIView?
    fileprivate let handleReturnFocusFromReloadButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCellAndViews()
    }

    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.remembersLastFocusedIndexPath = true
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 80)
        layout.itemSize = itemListLayout.itemSize
        layout.minimumInteritemSpacing = itemListLayout.horizontalSpacing
        layout.minimumLineSpacing = itemListLayout.verticalSpacing
    }    
    
    var showNavigationBar: Bool = false {
        didSet {
            collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
            navigationController!.isNavigationBarHidden = !showNavigationBar
            if showNavigationBar {
                let maskY = navigationController!.navigationBar.bounds.height
                let maskView = UIView(frame: CGRect(x: 0, y: maskY, width: view.bounds.width, height: view.bounds.height))
                maskView.backgroundColor = UIColor.white
                view.mask = maskView
            } else {
                view.mask = nil
            }
        }
    }

    var itemListLayout: ItemListLayout {
        return ItemListLayout.wide3Row
    }
    
    func registerCellAndViews() {
        collectionView.register(UINib(nibName: String(describing: StreamListHeaderReusableView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: StreamListHeaderReusableView.self))
        collectionView.register(UINib(nibName: String(describing: TitleHeaderReusableView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: TitleHeaderReusableView.self))
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
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        if handleReturnFocusFromReloadButton && prevFocusedView != nil {
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
        if handleReturnFocusFromReloadButton, let prevFocusedView = prevFocusedView {
            self.prevFocusedView = nil
            return [prevFocusedView]
        }
        return collectionView != nil ? [collectionView] : []
    }

    //MARK: - Actions
    
    @objc func onReload(_ sender: Any) {
        prevFocusedView = nil
        loadData()
    }
    
    //MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fatalError("Must me overridden")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Must me overridden")
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return sectionHeaderWithReloadButton(at: indexPath)
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }

    //MARK: - 

    func loadData() {
        fatalError("Must me overridden")
    }
    
    func hasReloadingHeader(section: Int) -> Bool {
        return true
    }
    
    func sectionHeaderWithReloadButton(at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: StreamListHeaderReusableView.self), for: indexPath) as! StreamListHeaderReusableView
        headerView.reloadButton.addTarget(self, action: #selector(onReload), for: .primaryActionTriggered)
        return headerView
    }
    
    func sectionHeaderWithTitle(_ title: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: TitleHeaderReusableView.self), for: indexPath) as! TitleHeaderReusableView
        headerView.titleLabel.text = title
        return headerView
    }
}
