//
//  StreamsService.swift
//  MSGG
//
//  Created by Maxim Solovyov on 28/03/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

class StreamsService: BaseAPIService {

    func getStreams(completion: @escaping ([Stream], Error?) -> ()) {
        let request = makeURLRequest(endpoint: .streams)
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { (data, response, error) in
            let foundError = self.getError(data: data, urlResponse: response, error: error)
            guard foundError == nil else {
                DispatchQueue.main.async {
                    completion([], foundError)
                }
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                let ggStreams = try jsonDecoder.decode(GoodGame.Streams.self, from: data!)
                let streams = ggStreams._embedded.streams.map({Stream(goodgameStream: $0)})
                DispatchQueue.main.async {
                    completion(streams, nil)
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }.resume()
    }
    
    func getViewers(streamID: Int, completion: @escaping (Int, Error?) -> ()) {
        let request = makeURLRequest(endpoint: .streams, ID: "\(streamID)")
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { (data, response, error) in
            let foundError = self.getError(data: data, urlResponse: response, error: error)
            guard foundError == nil else {
                DispatchQueue.main.async {
                    completion(0, foundError)
                }
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let ggStream = try jsonDecoder.decode(GoodGame.Stream.self, from: data!)
                DispatchQueue.main.async {
                    completion(Int(ggStream.viewers) ?? 0, nil)
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(0, error)
                }
            }
            }.resume()
    }

    func getPlayerInfo(playerSrc: String, completion: @escaping (PlayerInfo?, Error?) -> ()) {
        let request = makeURLRequest(endpoint: .player, ID: playerSrc)
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { (data, response, error) in
            let foundError = self.getError(data: data, urlResponse: response, error: error)
            guard foundError == nil else {
                DispatchQueue.main.async {
                    completion(nil, foundError)
                }
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let ggPlayerInfo = try jsonDecoder.decode(GoodGame.PlayerInfo.self, from: data!)
                let playerInfo = PlayerInfo(streamerAvatarURL: ggPlayerInfo.streamer_avatar)
                DispatchQueue.main.async {
                    completion(playerInfo, nil)
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }
}
