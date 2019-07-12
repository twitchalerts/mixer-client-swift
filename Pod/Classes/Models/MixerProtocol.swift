//
//  MixerProtocol.swift
//  MixerAPI
//
//  Created by Lev Sokolov on 7/12/19.
//

import SwiftyJSON

public struct MixerProtocol: Codable {
    public enum ProtocolType: String, Codable, CaseIterable {
        case ftl
        case rtmp
    }
    
    enum CodingKeys: CodingKey {
        case type
    }
    
    /// The protocol's type.
    public let type: ProtocolType?
    
    /// Used to initialize an ingest given JSON data.
    public init(json: JSON) {
        type = ProtocolType(rawValue: json["type"].string ?? "")
    }
}
