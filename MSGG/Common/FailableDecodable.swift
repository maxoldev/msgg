//
//  FailableDecodable.swift
//  MSGG
//
//  Created by Maxim Solovyov on 13/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

struct FailableDecodable<Base: Decodable> : Decodable {
    
    let base: Base?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            base = try container.decode(Base.self)
        } catch {
            Logger.warning("🛄", error)
            base = nil
        }
    }
}
