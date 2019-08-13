//
//  StreamVC.swift
//  MSGG
//
//  Created by Maxim Solovyov on 09/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage
import MSGGCore
import MSGGAPI
import MSGGFavorites

class StreamVC: UIViewController {

    var stream: MSGGCore.Stream?
    
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var streamerLabel: UILabel!
    @IBOutlet weak var viewersLabel: UILabel!
    @IBOutlet weak var gameButton: UIButton!
    @IBOutlet weak var qualityButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var noSupportedVideoFoundView: UIStackView!
    @IBOutlet weak var messageLabel: UILabel!
    
    fileprivate let streamService = DepedencyContainer.global.resolve(StreamsServiceProtocol.self)!
    fileprivate let gameService = DepedencyContainer.global.resolve(CategoriesServiceProtocol.self)!
    fileprivate let favoritesService = DepedencyContainer.global.resolve(FavoritesServiceProtocol.self)!
    fileprivate let settingsService = DepedencyContainer.global.resolve(SettingsService.self)!
    
    fileprivate var currentGame: Game?
    fileprivate var currentViewerCount = 0
    fileprivate var selectedSource: StreamSource?

    fileprivate var updatingViewerCountTimer: Timer?
    fileprivate var hidingControlsTimer: Timer?
    fileprivate var isMenuButtonDisabled = false
    
    fileprivate var player: AVPlayer {
        return playerView.player
    }
    fileprivate var hintView: HintView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showControls(false)
        setupGestureRecognizers()
        
        tryToLoadStream()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showControlsHintIfNeeded()
    }
    
    fileprivate func showControlsHintIfNeeded() {
        guard !settingsService.werePlayerControlsShown else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            let hintView = HintView()
            hintView.label.text = NSLocalizedString("controls-hint", comment: "")
            self.view.addSubview(hintView)
            self.view.layer.zPosition = 1000
            hintView.ms_pinEdgesToSuperview(constraintParams: [(.top, .greaterThanOrEqual, 60),
                                                               (.bottom, .equal, -60),
                                                               (.leading, .equal, 90),
                                                               (.trailing, .equal, -90)])
            self.hintView = hintView
            hintView.show(animated: true, autoHideTime: 5)
            hintView.onHideCompletion = { [weak self] in
                self?.hintView?.removeFromSuperview()
            }
        }
    }
    
    fileprivate func hideControlsHintViewIfNeeded() {
        hintView?.hide(animated: false)
    }
    
    fileprivate func tryToLoadStream() {
        if let stream = stream {
            currentViewerCount = stream.viewers
            setupUI()
            tryToLoadGameInfo()
            setupUpdatingViewerCountTimer()
            
            let lastSelectedStreamQuality = settingsService.lastSelectedStreamQuality
            if let selectedSource = selectStreamSource(stream.sources, accordingToLastSelectedQuality: lastSelectedStreamQuality) {
                Logger.info("Stream is about to start\n\(stream)")
                noSupportedVideoFoundView.isHidden = true
                playPauseButton.isHidden = false
                qualityButton.isHidden = false
                self.selectedSource = selectedSource
                restartVideo(url: selectedSource.url)
            } else {
                Logger.warning("No supported video streams found\n\(stream)")
                noSupportedVideoFoundView.isHidden = false
                messageLabel.text = stream.isOnline ? NSLocalizedString("no-supported-video-streams-found", comment: "") : NSLocalizedString("stream-offline", comment: "")
                playPauseButton.isHidden = true
                qualityButton.isHidden = true
            }
        } else {
            Logger.warning("No stream data passed")
            noSupportedVideoFoundView.isHidden = false
            messageLabel.text = NSLocalizedString("no-stream-data-passed", comment: "")
        }
    }
    
    fileprivate func selectStreamSource(_ sourcesSortedByQualityDescending: [StreamSource], accordingToLastSelectedQuality lastSelectedQuality: StreamQuality) -> StreamSource? {
        guard !sourcesSortedByQualityDescending.isEmpty else {
            return nil
        }
        
        for source in sourcesSortedByQualityDescending {
            if source.quality == lastSelectedQuality {
                return source
            }
        }
        
        // the same quiality wasn't found, so find closer to the value
        let sourcesWithBetterQuality = sourcesSortedByQualityDescending.filter({ $0.quality >= lastSelectedQuality })
        return sourcesWithBetterQuality.last ?? sourcesSortedByQualityDescending.first!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updatingViewerCountTimer?.invalidate()
        hidingControlsTimer?.invalidate()
    }
    
    fileprivate func setupUI() {
        titleLabel.text = stream!.title
        streamerLabel.text = stream!.streamer
        viewersLabel.text = "\(stream!.viewers)"
        updateFavoriteButton(isFavorite: favoritesService.isFavorite(channelID: stream!.channelID))
        updateStreamerAvatar(url: stream!.avatarURL)
    }
    
    fileprivate func setupUpdatingViewerCountTimer() {
        updatingViewerCountTimer = Timer.scheduledTimer(withTimeInterval: 120, repeats: true) { (timer) in
            self.updateViewerCount()
        }
    }

    fileprivate func restartHidingControlsTimer() {
        hidingControlsTimer?.invalidate()
        hidingControlsTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { (timer) in
            timer.invalidate()
            self.temporaryDisableMenuButton()
            self.showControls(false)
        }
    }

    fileprivate func updateStreamerAvatar(url: String) {
        avatarImageView.sd_setImage(with: URL(string: url), placeholderImage: nil,
                                    options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed])
    }
    
    fileprivate func updateViewerCount(_ count: Int) {
        viewersLabel.text = "\(count)"
    }
    
    fileprivate func tryToLoadGameInfo() {
        gameButton.isHidden = true
        guard let gameID = stream!.gameID else {
            return
        }
        gameService.getGameInfo(gameID: gameID) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                
                switch result {
                case let .success(game):
                    self.currentGame = game
                    self.gameButton.isHidden = false
                    self.gameButton.setTitle(game.title, for: .normal)

                case .failure:
                    break
                }
            }
        }
    }
    
    fileprivate func updateViewerCount() {
        streamService.getViewers(streamID: stream!.channelID) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch result {
                case let .success(viewerCount):
                    self.currentViewerCount = viewerCount
                    self.updateViewerCount(viewerCount)
                case .failure:
                    break
                }
            }
        }
    }

    fileprivate func updateFavoriteButton(isFavorite: Bool) {
        favoriteButton.setImage(UIImage(named: isFavorite ? "baseline_favorite_white" : "baseline_favorite_border_white"), for: .normal)
    }
    
    fileprivate func setupGestureRecognizers() {
        let menuGS = UITapGestureRecognizer(target: self, action: #selector(menuRemoteButtonPressed))
        menuGS.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        view.addGestureRecognizer(menuGS)

        let playGS = UITapGestureRecognizer(target: self, action: #selector(playRemoteButtonPressed))
        playGS.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)]
        view.addGestureRecognizer(playGS)

        let selectGS = UITapGestureRecognizer(target: self, action: #selector(selectRemoteButtonPressed))
        selectGS.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)]
        view.addGestureRecognizer(selectGS)

        let upDownGS = UITapGestureRecognizer(target: self, action: #selector(directionRemoteButtonPressed))
        upDownGS.allowedPressTypes = [NSNumber(value: UIPress.PressType.upArrow.rawValue),
                                      NSNumber(value: UIPress.PressType.downArrow.rawValue),
                                      NSNumber(value: UIPress.PressType.leftArrow.rawValue),
                                      NSNumber(value: UIPress.PressType.rightArrow.rawValue)]
        view.addGestureRecognizer(upDownGS)

        let swipeGS = UISwipeGestureRecognizer(target: self, action: #selector(remoteSwiped))
        swipeGS.direction = [.down, .up, .left, .right]
        view.addGestureRecognizer(swipeGS)
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [playPauseButton, favoriteButton]
    }
    
    fileprivate func showControls(_ show: Bool) {
        hideControlsHintViewIfNeeded()
        
        if show {
            settingsService.werePlayerControlsShown = true
            restartHidingControlsTimer()
        }
        
        guard controlsView.isHidden != !show else {
            return
        }
        
        if show {
            controlsView.isHidden = false
            controlsView.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.controlsView.alpha = 1
            }) { (_) in
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.controlsView.alpha = 0
            }) { (_) in
                self.controlsView.isHidden = true
            }
            hidingControlsTimer?.invalidate()
        }
    }
    
    fileprivate var areControlsShown: Bool {
        return !controlsView.isHidden
    }
    
    fileprivate func playPause() {
        if isPlaying {
            player.pause()
            playPauseButton.setImage(UIImage(named: "round_play_arrow_white")!, for: .normal)
        } else {
            player.play()
            playPauseButton.setImage(UIImage(named: "round_pause_white")!, for: .normal)
        }
    }
    
    fileprivate var isPlaying: Bool {
        return player.timeControlStatus != .paused
    }
    
    fileprivate func restartVideo(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        player.play()
    }
    
    fileprivate func selectStreamSource(_ source: StreamSource) {
        selectedSource = source
        restartVideo(url: source.url)
        settingsService.lastSelectedStreamQuality = source.quality
    }
    
    fileprivate func temporaryDisableMenuButton() {
        isMenuButtonDisabled = true
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (time) in
            time.invalidate()
            self.isMenuButtonDisabled = false
        }
    }
    
    //MARK: - Actions
    
    @IBAction func gameButtonTriggered(_ sender: UIButton) {
        guard let currentGame = currentGame else {
            return
        }
        DepedencyContainer.global.resolve(StreamRouterProtocol.self)!.didSelectGame(currentGame, currentVC: self)
    }
     
    @IBAction func qualityButtonTriggered(_ sender: UIButton) {
        guard let sources = stream?.sources else {
            return
        }
        let alert = UIAlertController(title: NSLocalizedString("select-stream-quality", comment: ""), message: nil, preferredStyle: .alert)
        sources.forEach { (source) in
            let title = source.quality.localizedTitle
            let action = UIAlertAction(title: title, style: .default, handler: { _ in
                self.selectStreamSource(source)
//                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            
            if source.url == selectedSource!.url {
                alert.preferredAction = action
            }
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: { _ in
//            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func playPauseButtonTriggered(_ sender: UIButton) {
        playPause()
    }
    
    @IBAction func favoriteButtonTriggered(_ sender: UIButton) {
        let channelID = stream!.channelID
        let newFavoriteState = !favoritesService.isFavorite(channelID: channelID)
        if newFavoriteState {
            favoritesService.addToFavorites(stream: stream!)
            updateFavoriteButton(isFavorite: newFavoriteState)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("remove-channel-from-favorites", comment: ""), message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("remove", comment: ""), style: .destructive, handler: { (_) in
                self.favoritesService.removeFromFavorites(channelID: channelID)
                self.updateFavoriteButton(isFavorite: false)
//                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            alert.preferredAction = action
            alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Gestures
    
    @objc func menuRemoteButtonPressed(_ sender: UITapGestureRecognizer) {
        if areControlsShown {
            showControls(false)
        } else if !isMenuButtonDisabled {
            DepedencyContainer.global.resolve(StreamRouterProtocol.self)!.didSelectBack(currentVC: self)
        }
    }
    
    @objc func playRemoteButtonPressed(_ sender: UITapGestureRecognizer) {
        playPause()
    }
    
    @objc func selectRemoteButtonPressed(_ sender: UITapGestureRecognizer) {
        showControls(true)
    }
    
    @objc func directionRemoteButtonPressed(_ sender: UITapGestureRecognizer) {
        showControls(true)
    }
    
    @objc func remoteSwiped(_ sender: UISwipeGestureRecognizer) {
        showControls(true)
    }
}
