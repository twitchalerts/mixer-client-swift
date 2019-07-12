//
//  MixerThumbnail.swift
//  Mixer API
//
//  Created by Jack Cook on 4/25/15.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import SwiftyJSON

/// A channel thumbnail object.
public struct MixerThumbnail {
    
    /// The identifier of the thumbnail.
    public let id: Int?
    
    /// The relid of the thumbnail.
    public let relid: Int?
    
    /// A URL of the thumbnail image.
    public let url: String?
    
    /// The store of the thumbnail on Mixer's servers.
    public let store: String?
    
    /// The path of the thumbnail on Mixer's servers.
    public let remotePath: String?
    
    /// The first time at which the channel was given a thumbnail.
    public let createdAt: Date?
    
    /// The most recent time at which the channel's thumbnail was updated.
    public let updatedAt: Date?
    
    /// The size of the thumbnail image.
    public var size: CGSize?
    
    /// Used to initialize a thumbnail given JSON data.
    public init(json: JSON) {
        if let size = json["meta"]["size"].array, let w = size[0].int, let h = size[1].int {
            let width = CGFloat(w)
            let height = CGFloat(h)
            self.size = CGSize(width: width, height: height)
        }
        
        id = json["id"].int
        relid = json["relid"].int
        url = json["url"].string
        store = json["store"].string
        remotePath = json["remotePath"].string
        createdAt = Date.fromMixer(json["createdAt"].string)
        updatedAt = Date.fromMixer(json["updatedAt"].string)
    }
}
