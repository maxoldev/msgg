//
//  Stream.swift
//  MSGG
//
//  Created by Maxim Solovyov on 09/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

typealias IDType = Int

struct Stream {
    let channelID: IDType
    let title: String
    let streamer: String
    let avatarURL: String
    let viewers: Int
    let playerSrc: String
    let previewURL: String
    let channelPosterURL: String
    let gameID: String?
    let isOnline: Bool
    let sources: [StreamSource]
}

struct PlayerInfo {
    let streamerAvatarURL: String
}

struct Game {
    let gameID: IDType
    let url: String
    let coverURL: String
    let title: String
}

struct Genre {
    let enTitle: String
    let ruTitle: String
    let coverURL: String
}

extension Stream {
    
    static func makeOffline(channelID: IDType, streamer: String, avatarURL: String) -> Stream {
        return Stream(channelID: channelID, title: "", streamer: streamer, avatarURL: avatarURL, viewers: 0, playerSrc: "", previewURL: "", channelPosterURL: "", gameID: nil, isOnline: false, sources: [])
    }
}
