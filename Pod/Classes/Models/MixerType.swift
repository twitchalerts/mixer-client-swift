//
//  MixerType.swift
//  Mixer API
//
//  Created by Jack Cook on 4/26/15.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import SwiftyJSON

/// The object of a game being played by a channel.
public struct MixerType: Codable {
    enum CodingKeys: CodingKey {
        case id
        case name
        case parent
        case desc
        case source
        case viewersCurrent
        case coverURL
        case online
    }
    
    /// The type's identifier.
    public let id: Int
    
    /// The name of the type.
    public let name: String
    
    /// The type's parent (e.g. game)
    public let parent: String?
    
    /// A short description of the type.
    public let desc: String?
    
    /// Where the type was initially found (e.g. player.me)
    public let source: String?
    
    /// The number of viewers currently watching channels playing this game.
    public let viewersCurrent: Int
    
    /// The URL of the type's thumbnail image.
    public let coverURL: URL?
    
    /// The number of channels currently playing this game.
    public let online: Int
    
    /// Used to initialize a type given JSON data.
    public init(json: JSON) {
        id = json["id"].int ?? 0
        name = json["name"].string ?? ""
        parent = json["parent"].string
        desc = json["description"].string
        source = json["source"].string
        viewersCurrent = json["viewersCurrent"].int ?? 0
        
        if let cover = json["coverUrl"].string {
            coverURL = URL(string: cover)
        } else {
            coverURL = nil
        }
        
        online = json["online"].int ?? 0
    }
}
