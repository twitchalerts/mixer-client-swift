//
//  MixerExpandedChannel.swift
//  MixerAPI
//
//  Created by Lev Sokolov on 7/12/19.
//

import SwiftyJSON

public class MixerExpandedChannel: MixerChannel {
	enum MixerExpandedChannelCodingKeys: CodingKey {
		case streamKey
	}
	
	public var streamKey: String?
	
	public override init(json: JSON) {
		self.streamKey = json["streamKey"].string
		
		super.init(json: json)
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: MixerExpandedChannelCodingKeys.self)
		self.streamKey = try container.decodeIfPresent(String.self, forKey: .streamKey)
		
		try super.init(from: decoder)
	}
}
