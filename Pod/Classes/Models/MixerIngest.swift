//
//  MixerIngest.swift
//  Pods
//
//  Created by Jack Cook on 7/12/16.
//
//

import SwiftyJSON

/// An ingest object.
public struct MixerIngest: Codable {
    enum CodingKeys: CodingKey {
        case name
        case host
        case pingTest
        case protocols
    }
    
    /// The ingest's name.
    public let name: String?
    
    /// The ingest's host url.
    public let host: String?
    
    /// A WSS URL that can be used to test your connection to the ingest.
    public let pingTest: String?
    
    /// A list of protocols supported by this ingest server.
    public let protocols: [MixerProtocol]?
    
    /// Used to initialize an ingest given JSON data.
    public init(json: JSON) {
        name = json["name"].string
        host = json["host"].string
        pingTest = json["pingTest"].string
        
        var protocols = [MixerProtocol]()
        
        if let protocolsList = json["protocols"].array {
            for `protocol` in protocolsList {
                protocols.append(MixerProtocol(json: `protocol`))
            }
        }
        
        self.protocols = protocols
    }
}
