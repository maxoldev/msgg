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

class StreamListVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let service = StreamsService()
    var streams = [Stream]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func loadData() {
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
            self.streams = streams
            self.collectionView.reloadData()
            self.setNeedsFocusUpdate()
        }
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [collectionView]
    }
    
    @IBAction func onReload(_ sender: Any) {
        loadData()
    }
}

extension StreamListVC: UICollectionViewDataSource {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 50
//    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return streams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: StreamCVCell.self), for: indexPath) as! StreamCVCell
        let stream = streams[indexPath.row]
        cell.setup(streamer: stream.streamer, title: stream.title, viewers: stream.viewers, thumbURL: stream.thumbURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: StreamListHeaderReusableView.self), for: indexPath)
        
        return headerView
    }
}

extension StreamListVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stream = streams[indexPath.row]
//        let hls_id = stream.hlsId
//        let videoURL = URL(string: "https://hls.goodgame.ru/hls/\(hls_id).m3u8")!
//        let player = AVPlayer(url: videoURL)
//        let vc = AVPlayerViewController()
//        vc.showsPlaybackControls = false
//        vc.player = player
//        player.play()
        let vc = SharedComponents.vcFactory.create(.stream) as! StreamVC
        vc.stream = stream
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    }
}

extension StreamListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let itemsInRow = 3
        let itemWidth = (collectionViewWidth - (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing * CGFloat(itemsInRow - 1)) / CGFloat(itemsInRow)
        let itemHeight = itemWidth * 0.6
        let size = CGSize(width: itemWidth, height: itemHeight)
        return size
    }
}
