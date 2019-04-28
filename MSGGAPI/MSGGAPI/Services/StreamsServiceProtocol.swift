//
//  StreamsServiceProtocol
//  MSGGAPI
//
//  Created by Maxim Solovyov on 19/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation
import MSGGCore

public protocol StreamsServiceProtocol {
    
    func getStreams(limit: Int, gameURL: String?, skipStreamsWithoutSupportedVideo: Bool, completion: @escaping (Result<[MSGGCore.Stream], Error>) -> ())
    func getViewers(streamID: Int, completion: @escaping (Result<Int, Error>) -> ())
}
