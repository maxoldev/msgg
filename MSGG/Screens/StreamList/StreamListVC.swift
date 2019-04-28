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
import Swinject
import MSGGCore
import MSGGAPI

class StreamListVC: ItemListVC<MSGGCore.Stream> {
    
    enum Context {
        case allStreams
        case game(Game)
        case genre(Genre)
    }
    
    fileprivate let service = DepedencyContainer.global.resolve(StreamsServiceProtocol.self)!
    var context = Context.allStreams
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBarIfNeeded()
    }
    
    override func loadData() {
        isLoading = true
        
        var gameURL: String?
        switch context {
        case let .game(game):
            gameURL = game.url
        default:
            break
        }
        
        service.getStreams(limit: CrossTargetConfig.itemLimit, gameURL: gameURL, skipStreamsWithoutSupportedVideo: false) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.isLoading = false

                switch result {
                case let .success(streams):
                    self.items = streams
                    self.collectionView.reloadData()
                    self.setNeedsFocusUpdate()
                    
                case .failure:
                    break
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigationBarIfNeeded()
    }
    
    fileprivate func updateNavigationBarIfNeeded() {
        switch context {
        case let .game(game):
            title = game.title
            showNavigationBar = true
        case let .genre(genre):
            title = genre.localizedTitle
            showNavigationBar = true
        default:
            showNavigationBar = false
        }
    }
    
    fileprivate func hideNavigationBarIfNeeded() {
        switch context {
        case .game, .genre:
            navigationController?.isNavigationBarHidden = true
        default:
            break
        }
    }
    
    override func registerCellAndViews() {
        super.registerCellAndViews()
        collectionView.register(UINib(nibName: String(describing: StreamCVCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: StreamCVCell.self))
    }
    
    override var itemListLayout: ItemListLayout {
        return AppAppearance.streamsItemListLayout
    }
    
    //MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: StreamCVCell.self), for: indexPath) as! StreamCVCell
        let stream = items[indexPath.row]
        let needToShowWarning = stream.sources.isEmpty
        cell.setup(streamer: stream.streamer, title: stream.title, viewers: stream.viewers, previewURL: stream.previewURL, posterURL: stream.channelPosterURL, warning: needToShowWarning)
        return cell
    }
    
    //MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stream = items[indexPath.row]
        DepedencyContainer.global.resolve(StreamListRouterProtocol.self)!.didSelectStream(stream)
    }
}
