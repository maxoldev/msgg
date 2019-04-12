//
//  Stream.swift
//  MSGG
//
//  Created by Maxim Solovyov on 09/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

typealias ChannelID = Int

struct Stream {
    let channelID: ChannelID
    let streamer: String
    let url: String
    let viewers: Int
    let playerSrc: String
    let title: String
    let thumbURL: String
    let game: Game
}

struct PlayerInfo {
    let streamerAvatarURL: String
}

struct Game {
    let coverURL: String
    let title: String
    let url: String
}
