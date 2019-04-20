//
//  StreamsServiceProtocol
//  MSGG
//
//  Created by Maxim Solovyov on 19/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

protocol StreamsServiceProtocol {
    
    func getStreams(limit: Int, gameURL: String?, skipStreamsWithoutSupportedVideo: Bool, completion: @escaping ([Stream], Error?) -> ())
    func getViewers(streamID: Int, completion: @escaping (Int, Error?) -> ())
}
