//
//  FavoriteListVC.swift
//  MSGG
//
//  Created by Maxim Solovyov on 14/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

class FavoriteListVC: BaseCollectionVC {

    enum Section {
        case reload
        case online(streams: [Stream])
        case offline(streamInfos: [FavoriteStreamInfo])
    }
    
    var sections = [Section.reload]
    fileprivate var needToReload = false
    fileprivate let favoritesService = DepedencyContainer.global.resolve(FavoritesService.self)!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdatedNotified), name: FavoritesServiceImpl.listUpdatedNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needToReload {
            needToReload = false
            loadData()
        }
    }
    
    override func loadData() {
        isLoading = true
        favoritesService.getStreams { [weak self] (onlineStreams, offlineStreamInfos, error) in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard error == nil, let self = self else {
                    return
                }
                var sections = [Section.reload]
                if !onlineStreams.isEmpty {
                    sections.append(.online(streams: onlineStreams))
                }
                if !offlineStreamInfos.isEmpty {
                    sections.append(.offline(streamInfos: offlineStreamInfos))
                }
                self.sections = sections
                self.collectionView.reloadData()
            }
        }
    }
    
    override func registerCellAndViews() {
        super.registerCellAndViews()
        collectionView.register(UINib(nibName: String(describing: StreamCVCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: StreamCVCell.self))
        collectionView.register(UINib(nibName: String(describing: StreamerCVCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: StreamerCVCell.self))
    }

    //MARK: - Notification
    
    @objc func favoritesUpdatedNotified() {
        needToReload = true
    }

    //MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        case .reload:
            return 0
        case let .online(streams):
            return streams.count
        case let .offline(streamInfos):
            return streamInfos.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .reload:
            fatalError("Reload button section must not contain cells")

        case let .online(streams):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: StreamCVCell.self), for: indexPath) as! StreamCVCell
            let stream = streams[indexPath.row]
            let needToShowWarning = stream.sources.isEmpty
            cell.setup(streamer: stream.streamer, title: stream.title, viewers: stream.viewers, previewURL: stream.previewURL, posterURL: stream.channelPosterURL, warning: needToShowWarning)
            return cell

        case let .offline(streamInfos):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: StreamerCVCell.self), for: indexPath) as! StreamerCVCell
            let info = streamInfos[indexPath.row]
            cell.setup(streamer: info.streamer, avatarURL: info.avatarURL)
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .reload:
            return sectionHeaderWithReloadButton(at: indexPath)
            
        case .online:
            return sectionHeaderWithTitle(NSLocalizedString("online", comment: ""), at: indexPath)
            
        case .offline:
            return sectionHeaderWithTitle(NSLocalizedString("offline", comment: ""), at: indexPath)
        }
    }

    //MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = sections[indexPath.section]
        let stream: Stream
        switch sectionType {
        case .reload:
            fatalError("Reload button section must not contain cells")
            
        case let .online(streams):
            stream = streams[indexPath.row]
            
        case let .offline(streamInfos):
            let si = streamInfos[indexPath.row]
            stream = Stream.makeOffline(channelID: si.channelID, streamer: si.streamer, avatarURL: si.avatarURL)
        }
        let vc = SharedComponents.vcFactory.create(.stream) as StreamVC
        vc.stream = stream
        SharedComponents.router.openViewControllerModally(vc)
    }

    //MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .reload:
            fatalError("Reload button section must not contain cells")
        
        case .online:
            return CGSize(width: 375, height: 301)

        case .offline:
            return CGSize(width: 204, height: 271
            )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let sectionType = sections[section]
        switch sectionType {
        case .reload:
            return 0
        
        case .online:
            return 80

        case .offline:
            return 52
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let sectionType = sections[section]
        switch sectionType {
        case .reload:
            return 0
            
        case .online:
            return 50
            
        case .offline:
            return 50
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 10, height: 80)
    }
}
