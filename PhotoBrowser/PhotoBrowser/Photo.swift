//
//  Photo.swift
//  PhotoBrowser
//
//  Created by vinsol on 27/02/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore

enum DownloadError {
    case invalidUrl
    case failed
    case invalidImage
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
            completion(nil,.invalidUrl)
            return
        }
        
        let task = downloadSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(nil, .failed)
            } else if let data = data, let image = UIImage(data: data) {
                let createdPhoto = Photo(url: self.url, image: image)
                completion(createdPhoto,nil)
            } else {
                completion(nil, .invalidImage)
            }
        }
        
        task.resume()
    }
    
    static func downloadAll(completion: @escaping PhotoDownloadCompletionBlock) {
        if let userId = AccessToken.current?.userID, AccessToken.current?.hasGranted(Permission.userPhotos) == true {
            GraphRequest(graphPath: "/\(userId)/photos/uploaded", parameters: ["fields" : "images"]).start { (_, result, error) in
                if error != nil {
                    print(error ?? "unknown error")
                    return
                } else {
                    if let fbResult = result as? [String : Any], let resultArray = fbResult["data"] as? [[String : Any]] {
                        print(fbResult["data"])
                        for item in resultArray {
                            if let images = item["images"] as? [[String : Any]], let url = images[0]["source"] as? String {
                                self.downloadPhoto(url: url, completion: completion)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private static func downloadPhoto(url: String, completion: @escaping PhotoDownloadCompletionBlock) {
        let _ = Photo(url: url, completionHandler: completion)
    }
}
