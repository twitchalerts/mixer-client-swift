//
//  MixerExpandedChannel.swift
//  MixerAPI
//
//  Created by Lev Sokolov on 7/12/19.
//

import SwiftyJSON

public class MixerExpandedChannel: MixerChannel {
	public var streamKey: String?
	
	public override init(json: JSON) {
		self.streamKey = json["streamKey"].string
		
		super.init(json: json)
	}
}
