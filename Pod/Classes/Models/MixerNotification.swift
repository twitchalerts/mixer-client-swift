//
//  MixerNotification.swift
//  Pods
//
//  Created by Jack Cook on 8/9/16.
//
//

import SwiftyJSON

/// A notification object.
public struct MixerNotification {
    
    /// The payload, containing the notification's data.
    public let payload: [String: Any]?
    
    /// The date, in UTC, at which this notification was sent.
    public let sentAt: Date?
    
    /// The type of notification.
    public let type: String
    
    /// The identifier of the user who received this notification.
    public let userId: Int
    
    /// The notification's identifier.
    public let id: String?
    
    /// Used to initialize a notification given JSON data.
    public init(json: JSON) {
        payload = json["payload"].dictionaryObject
        sentAt = Date.fromMixer(json["sentAt"].string)
        type = json["type"].string ?? "unknown"
        userId = json["userId"].int ?? 0
        id = json["id"].string
    }
}
