//
//  StreamListVC.swift
//  MSGG
//
//  Created by Maxim Solovyov on 26/10/2018.
//  Copyright © 2018 MaximSolovyov. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class StreamListVC: ItemListVC<Stream> {
    
    let service = StreamsService()
    
    override func loadData() {
        collectionView.isHidden = true
        activityIndicator.startAnimating()
        service.getStreams { [weak self] (streams, error) in
            guard let self = self else {
                return
            }
            self.activityIndicator.stopAnimating()
            self.collectionView.isHidden = false
            
            guard error == nil else {
                return
            }
            self.items = streams
            self.collectionView.reloadData()
            self.setNeedsFocusUpdate()
        }
    }
    
    override func registerCellAndViews() {
        super.registerCellAndViews()
        collectionView.register(UINib(nibName: String(describing: StreamCVCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: StreamCVCell.self))
    }
    
    override var itemSize: CGSize {
        return CGSize(width: 573, height: 343)
    }
    
    override var horizontalSpacing: CGFloat {
        return 10
    }
    
    override var verticalSpacing: CGFloat {
        return 50
    }

    //MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: StreamCVCell.self), for: indexPath) as! StreamCVCell
        let stream = items[indexPath.row]
        cell.setup(streamer: stream.streamer, title: stream.title, viewers: stream.viewers, thumbURL: stream.thumbURL)
        return cell
    }
    
    //MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stream = items[indexPath.row]
        let vc = SharedComponents.vcFactory.create(.stream) as StreamVC
        vc.stream = stream
        navigationController?.pushViewController(vc, animated: true)
    }
}
