//
//  MixerThumbnail.swift
//  Mixer API
//
//  Created by Jack Cook on 4/25/15.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import SwiftyJSON

/// A channel thumbnail object.
public struct MixerThumbnail: Codable {
    public struct Meta: Codable {
        enum CodingKeys: CodingKey {
            case size
        }
        
        var size: [Int]?
    }
    
    enum CodingKeys: CodingKey {
        case id
        case relid
        case url
        case store
        case remotePath
        case createdAt
        case updatedAt
        case meta
        case size
    }
    
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
    
    public var meta: Meta?
    
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        relid = try container.decodeIfPresent(Int.self, forKey: .relid)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        store = try container.decodeIfPresent(String.self, forKey: .store)
        remotePath = try container.decodeIfPresent(String.self, forKey: .remotePath)
        createdAt = Date.fromMixer(try container.decodeIfPresent(String.self, forKey: .createdAt))
        updatedAt = Date.fromMixer(try container.decodeIfPresent(String.self, forKey: .updatedAt))
        meta = try container.decodeIfPresent(Meta.self, forKey: .meta)
        
        if let w = meta?.size?[0], let h = meta?.size?[0] {
            self.size = CGSize(width: w, height: h)
        }
    }
}
