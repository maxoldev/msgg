//
//  TopShelfExtensionDataCoder.swift
//  TopShelf
//
//  Created by Maxim Solovyov on 13/08/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation
import MSGGCore
import MSGGAPI

class TopShelfExtensionDataCoder {
    
    func getStream(from url: URL) -> MSGGCore.Stream? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let encodedStr = components.queryItems?.first(where: { $0.name == CrossTargetConfig.streamQueryItemName })?.value,
            let data = encodedStr.data(using: .utf8) else {
                return nil
        }
        guard let ggStream = try? JSONDecoder().decode(GoodGame.Stream.self, from: data) else {
            return nil
        }
        let stream = MSGGCore.Stream(goodgameStream: ggStream)
        return stream
    }
    
    func makeURL(for stream: MSGGCore.Stream) -> URL? {
        var components = URLComponents()
        components.scheme = CrossTargetConfig.scheme
        let ggStream = GoodGame.Stream(stream: stream)
        guard let encoded = try? JSONEncoder().encode(ggStream) else {
            return nil
        }
        components.queryItems = [URLQueryItem(name: CrossTargetConfig.streamQueryItemName, value: String(data: encoded, encoding: .utf8))]
        return components.url
    }
}
