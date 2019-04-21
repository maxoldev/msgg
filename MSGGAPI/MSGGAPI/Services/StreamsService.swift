//
//  StreamsService.swift
//  MSGG
//
//  Created by Maxim Solovyov on 28/03/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation
import MSGGCore

public class StreamsService: BaseAPIService, StreamsServiceProtocol {

    public func getStreams(limit: Int, gameURL: String?, skipStreamsWithoutSupportedVideo: Bool, completion: @escaping (Result<[MSGGCore.Stream], Error>) -> ()) {
        var queryItems = [URLQueryItem(name: "onpage", value: String(limit))]
        if let gameURL = gameURL {
            queryItems.append(URLQueryItem(name: "game", value: gameURL))
        }
        let request = makeURLRequest4(endpoint: .stream, queryItems: queryItems)
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let foundError = self.getError(data: data, urlResponse: response, error: error) {
                Logger.error("🌐", foundError)
                completion(.failure(foundError))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let ggStreams = try jsonDecoder.decode(GoodGame.Streams.self, from: data!)
                let ggStreamsArray = ggStreams.streams.compactMap({ $0.base })  // skip objects with incomplete/fail data model
                let streams: [MSGGCore.Stream]
                if skipStreamsWithoutSupportedVideo {
                    streams = ggStreamsArray.compactMap({ (ggStream) -> MSGGCore.Stream? in
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
                completion(.success(streams))
            } catch {
                Logger.error("🛄", error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    public func getViewers(streamID: Int, completion: @escaping (Result<Int, Error>) -> ()) {
        let request = makeURLRequest(endpoint: .streams, ID: "\(streamID)")
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let foundError = self.getError(data: data, urlResponse: response, error: error) {
                Logger.error("🌐", foundError)
                completion(.failure(foundError))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let ggStream = try jsonDecoder.decode(GoodGame.StreamOld.self, from: data!)
                completion(.success(Int(ggStream.viewers) ?? 0))
            } catch {
                Logger.error("🛄", error)
                completion(.failure(error))
            }
        }.resume()
    }

//    public func getPlayerInfo(playerSrc: String, completion: @escaping (Result<PlayerInfo, Error>) -> ()) {
//        let request = makeURLRequest(endpoint: .player, ID: playerSrc)
//        let session = URLSession(configuration: .default)
//        
//        session.dataTask(with: request) { [weak self] (data, response, error) in
//            guard let self = self else { return }
//            
//            if let foundError = self.getError(data: data, urlResponse: response, error: error) {
//                Logger.error("🌐", foundError)
//                completion(.failure(foundError))
//                return
//            }
//            
//            do {
//                let jsonDecoder = JSONDecoder()
//                let ggPlayerInfo = try jsonDecoder.decode(GoodGame.PlayerInfo.self, from: data!)
//                let playerInfo = PlayerInfo(streamerAvatarURL: ggPlayerInfo.streamer_avatar)
//                completion(.success(playerInfo))
//            } catch {
//                Logger.error("🛄", error)
//                completion(.failure(error))
//            }
//        }.resume()
//    }
}
