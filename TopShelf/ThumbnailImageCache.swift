//
//  ThumbnailImageCache.swift
//  TopShelf
//
//  Created by Maxim Solovyov on 13/08/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation
import MSGGCore

class ThumbnailImageCache {
    
    func recreateImageCacheFolder() {
        try? FileManager.default.removeItem(atPath: getImageCacheFolderPath)
        do {
            try FileManager.default.createDirectory(atPath: getImageCacheFolderPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            Logger.error(error)
        }
    }

    func downloadImageWithURLAndReturnLocalURL(_ url: URL) -> URL? {
        do {
            let data = try Data(contentsOf: url)
            let filename = "\(UUID())"
            let filepath = NSString(string: getImageCacheFolderPath).appendingPathComponent(filename)
            let localFileURL = URL(fileURLWithPath: filepath)
            try data.write(to: localFileURL)
            return localFileURL
        } catch {
            return nil
        }
    }
    
    fileprivate lazy var getImageCacheFolderPath: String = {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let imageCacheFolder = NSString(string: paths.first!).appendingPathComponent("preview_images")
        return imageCacheFolder
    }()
}
