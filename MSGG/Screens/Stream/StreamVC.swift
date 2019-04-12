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

class StreamVC: UIViewController {

    var stream: Stream?
    var currentViewerCount = 0
    var selectedQuality = StreamQuality.source
    
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
    
    let service = StreamsService()
    var updatingViewerCountTimer: Timer?
    var hidingControlsTimer: Timer?
    
    fileprivate var player: AVPlayer {
        return playerView.player
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showControls(false)
        
        setupGestureRecognizers()
        
        if let _ = stream {
            currentViewerCount = stream!.viewers
            setupUI()
            restartStreamWithQuality(selectedQuality)
            updateStreamInfo()
        }
        
        setupUpdatingViewerCountTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updatingViewerCountTimer?.invalidate()
        hidingControlsTimer?.invalidate()
    }
    
    fileprivate func setupUI() {
        gameButton.setTitle(stream!.game.title, for: .normal)
        titleLabel.text = stream!.title
        streamerLabel.text = stream!.streamer
        viewersLabel.text = "\(stream!.viewers)"
        updateFavoriteButton(isFavorite: SharedComponents.favoritesService.isFavorite(channelID: stream!.channelID))
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
            self.showControls(false)
        }
    }

    fileprivate func updateStreamerAvatar(url: String) {
        avatarImageView.sd_setImage(with: URL(string: url), placeholderImage: nil, options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], context: nil)
    }
    
    fileprivate func updateViewerCount(_ count: Int) {
        viewersLabel.text = "\(count)"
    }
    
    fileprivate func updateStreamInfo() {
        service.getPlayerInfo(playerSrc: stream!.playerSrc) { [weak self] (info, error) in
            guard let self = self, error == nil, let info = info else {
                return
            }
            self.updateStreamerAvatar(url: info.streamerAvatarURL)
        }
    }

    fileprivate func updateViewerCount() {
        service.getViewers(streamID: stream!.channelID) { [weak self] (viewerCount, error) in
            guard let self = self, error == nil else {
                return
            }
            self.currentViewerCount = viewerCount
            self.updateViewerCount(viewerCount)
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

        let upDownGS = UITapGestureRecognizer(target: self, action: #selector(upDownRemoteButtonsPressed))
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
        return [playPauseButton]
    }
    
    fileprivate func showControls(_ show: Bool) {
        if show {
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
    
    fileprivate func restartStreamWithQuality(_ quality: StreamQuality) {
        let videoURL = makeVideoURLForStreamQuality(quality)
        player.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
        player.play()
    }
    
    fileprivate func setStreamQuality(_ quality: StreamQuality) {
        selectedQuality = quality
        restartStreamWithQuality(quality)
    }
    
//    fileprivate func updateQualityButton() {
//        qualityButton.setTitle(selectedQuality.title, for: .normal)
//    }
    
    fileprivate func makeVideoURLForStreamQuality(_ quality: StreamQuality) -> URL {
        let hls_id = stream!.playerSrc
        let string = String(format: APIConstants.baseVideoURL, "\(hls_id)\(quality.urlSuffix)")
        let videoURL = URL(string: string)!
        return videoURL
    }
    
    //MARK: - Actions
    
    @IBAction func gameButtonTriggered(_ sender: UIButton) {
    }
    
    @IBAction func qualityButtonTriggered(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select stream quality", message: nil, preferredStyle: .alert)
        StreamQuality.allCases.forEach { (quality) in
            let action = UIAlertAction(title: quality.title, style: .default, handler: { _ in
                self.setStreamQuality(quality)
//                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            
            if quality == selectedQuality {
                alert.preferredAction = action
            }
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
//            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func playPauseButtonTriggered(_ sender: UIButton) {
        playPause()
    }
    
    @IBAction func favoriteButtonTriggered(_ sender: UIButton) {
        let channelID = stream!.channelID
        let newFavoriteState = !SharedComponents.favoritesService.isFavorite(channelID: channelID)
        if newFavoriteState {
            SharedComponents.favoritesService.addToFavorites(channelID: channelID)
            updateFavoriteButton(isFavorite: newFavoriteState)
        } else {
            let alert = UIAlertController(title: "Do you want to remove channel from the favorite?", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Remove", style: .destructive, handler: { (_) in
                SharedComponents.favoritesService.removeFromFavorites(channelID: channelID)
                self.updateFavoriteButton(isFavorite: false)
//                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            alert.preferredAction = action
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Gestures
    
    @objc func menuRemoteButtonPressed(_ sender: UITapGestureRecognizer) {
        if areControlsShown {
            showControls(false)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func playRemoteButtonPressed(_ sender: UITapGestureRecognizer) {
        playPause()
    }
    
    @objc func selectRemoteButtonPressed(_ sender: UITapGestureRecognizer) {
        showControls(true)
    }
    
    @objc func upDownRemoteButtonsPressed(_ sender: UITapGestureRecognizer) {
        showControls(true)
    }
    
    @objc func remoteSwiped(_ sender: UISwipeGestureRecognizer) {
        showControls(true)
    }
}
