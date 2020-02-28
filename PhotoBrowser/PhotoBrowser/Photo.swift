//
//  Photo.swift
//  PhotoBrowser
//
//  Created by vinsol on 27/02/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import Foundation
import UIKit

enum DownloadError {
    case INVALID_URL
    case FAILED
    case INVALID_IMAGE
}

typealias PhotoDownloadCompletionBlock = (_ image: Photo?, _ error: DownloadError?) -> Void

private let downloadSession = URLSession(configuration: URLSessionConfiguration.default)

final class Photo {
    private(set) var image: UIImage?
    private let url: String
    
    init(url: String, completionHandler: @escaping PhotoDownloadCompletionBlock) {
        self.url = url
        download(completion: completionHandler)
    }
    
    private init(url: String, image: UIImage) {
        self.url = url
        self.image = image
    }
    
    private func download(completion: @escaping PhotoDownloadCompletionBlock) {
        guard let url = URL(string: self.url) else {
            completion(nil,.INVALID_URL)
            return
        }
        
        let task = downloadSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(nil, .FAILED)
            } else if let data = data, let image = UIImage(data: data) {
                let createdPhoto = Photo(url: self.url, image: image)
                completion(createdPhoto,nil)
            } else {
                completion(nil, .INVALID_IMAGE)
            }
        }
        
        task.resume()
    }
}
