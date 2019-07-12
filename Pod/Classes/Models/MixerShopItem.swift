//
//  MixerShopItem.swift
//  Mixer
//
//  Created by Jack Cook on 1/9/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import SwiftyJSON

/// An item in Mixer's shop. More will be implemented when items are added to the shop.
public struct MixerShopItem {
    
    /// The title of the shop item.
    public let title: String?
    
    /// Used to initialize a shop item given JSON data.
    public init(json: JSON) {
        title = json["title"].string
    }
}
