//
//  Stream.swift
//  MSGGCore
//
//  Created by Maxim Solovyov on 09/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

public typealias IDType = Int

public struct Stream {
    
    public let channelID: IDType
    public let title: String
    public let streamer: String
    public let avatarURL: String
    public let viewers: Int
    public let playerSrc: String
    public let previewURL: String
    public let channelPosterURL: String
    public let gameID: String?
    public let isOnline: Bool
    public let sources: [StreamSource]

    public init(channelID: IDType, title: String, streamer: String, avatarURL: String, viewers: Int, playerSrc: String, previewURL: String, channelPosterURL: String, gameID: String?, isOnline: Bool, sources: [StreamSource]) {
        self.channelID = channelID
        self.title = title
        self.streamer = streamer
        self.avatarURL = avatarURL
        self.viewers = viewers
        self.playerSrc = playerSrc
        self.previewURL = previewURL
        self.channelPosterURL = channelPosterURL
        self.gameID = gameID
        self.isOnline = isOnline
        self.sources = sources
    }
    
    public static func makeOffline(channelID: IDType, streamer: String, avatarURL: String) -> Stream {
        return Stream(channelID: channelID, title: "", streamer: streamer, avatarURL: avatarURL, viewers: 0, playerSrc: "", previewURL: "", channelPosterURL: "", gameID: nil, isOnline: false, sources: [])
    }
}
