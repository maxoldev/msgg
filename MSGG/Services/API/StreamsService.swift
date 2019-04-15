//
//  StreamsService.swift
//  MSGG
//
//  Created by Maxim Solovyov on 28/03/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

class StreamsService: BaseAPIService {

    func getStreams(limit: Int = 5000, gameURL: String? = nil, skipStreamsWithoutSupportedVideo: Bool, completion: @escaping ([Stream], Error?) -> ()) {
        var queryItems = [URLQueryItem(name: "onpage", value: String(limit))]
        if let gameURL = gameURL {
            queryItems.append(URLQueryItem(name: "game", value: gameURL))
        }
        let request = makeURLRequest4(endpoint: .stream, queryItems: queryItems)
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { (data, response, error) in
            let foundError = self.getError(data: data, urlResponse: response, error: error)
            guard foundError == nil else {
                completion([], foundError)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let ggStreams = try jsonDecoder.decode(GoodGame.Streams.self, from: data!)
                let ggStreamsArray = ggStreams.streams.compactMap({ $0.base })  // skip objects with incomplete data model
                let streams: [Stream]
                if skipStreamsWithoutSupportedVideo {
                    streams = ggStreamsArray.compactMap({ (ggStream) -> Stream? in
                        if !ggStream.status {  // offline
                            return nil
                        }
                        let stream = Stream(goodgameStream: ggStream)
                        if stream.sources.isEmpty {  // has only smil source
                            return nil
                        } else {
                            return stream
                        }
                    })
                } else {
                    streams = ggStreamsArray.map({Stream(goodgameStream: $0)})
                }
                completion(streams, nil)
            } catch {
                print(error)
                completion([], error)
            }
        }.resume()
    }
    
    func getViewers(streamID: Int, completion: @escaping (Int, Error?) -> ()) {
        let request = makeURLRequest(endpoint: .streams, ID: "\(streamID)")
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { (data, response, error) in
            let foundError = self.getError(data: data, urlResponse: response, error: error)
            guard foundError == nil else {
                completion(0, foundError)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let ggStream = try jsonDecoder.decode(GoodGame.StreamOld.self, from: data!)
                completion(Int(ggStream.viewers) ?? 0, nil)
            } catch {
                print(error)
                completion(0, error)
            }
        }.resume()
    }

    func getPlayerInfo(playerSrc: String, completion: @escaping (PlayerInfo?, Error?) -> ()) {
        let request = makeURLRequest(endpoint: .player, ID: playerSrc)
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { (data, response, error) in
            let foundError = self.getError(data: data, urlResponse: response, error: error)
            guard foundError == nil else {
                completion(nil, foundError)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let ggPlayerInfo = try jsonDecoder.decode(GoodGame.PlayerInfo.self, from: data!)
                let playerInfo = PlayerInfo(streamerAvatarURL: ggPlayerInfo.streamer_avatar)
                completion(playerInfo, nil)
            } catch {
                print(error)
                completion(nil, error)
            }
        }.resume()
    }
}
