//
//  MixerEmoticon.swift
//  Pods
//
//  Created by Jack Cook on 7/13/16.
//
//

import SwiftyJSON

/// An emoticon object.
public struct MixerEmoticon {
    
    /// The emoticon's name (what needs to be typed into chat).
    public let name: String
    
    /// The emoticon's position in its spritesheet.
    public let position: CGPoint
    
    /// The emoticon's size in its spritesheet.
    public let size: CGSize
    
    /// Used to initialize an emoticon given JSON data.
    public init(name: String, json: JSON) {
        self.name = name
        
        let x = json["x"].int ?? 0
        let y = json["y"].int ?? 0
        let w = json["width"].int ?? 22
        let h = json["height"].int ?? 22
        
        position = CGPoint(x: CGFloat(x), y: CGFloat(y))
        size = CGSize(width: CGFloat(w), height: CGFloat(h))
    }
    
    /**
     Crops an emoticon image from its spritesheet.
     
     :param: spritesheet The entire spritesheet image.
     :returns: The cropped emoticon image.
     */
    public func imageFromSpritesheet(_ spritesheet: UIImage) -> UIImage? {
        let croppedRect = CGRect(x: position.x, y: position.y, width: size.width, height: size.height)
        if let image = spritesheet.cgImage?.cropping(to: croppedRect) {
            return UIImage(cgImage: image)
        }
        
        return nil
    }
}
