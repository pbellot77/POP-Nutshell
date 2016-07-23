//
//  Thumbnail.swift
//  
//
//  Created by Patrick Bellot on 7/15/16.
//
//

import Foundation
import CoreData
import SwiftyJSON


class Thumbnail: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
struct Resolution {
    
    static let Res = "high"
    static let ResWidth = 480
    static let ResHeight = 360
    
    }
    /**
     Convenience initialiser that allows a Thumbnail to be created from a given
     set of parameters.  For further details see:
     https://developers.google.com/youtube/v3/docs/videos#resource
     
     - parameter size: The size of the thumbnail - Can be one of:
     
     - default – The default thumbnail image. The default thumbnail for a
     video – or a resource that refers to a video, such as a playlist item
     or search result – is 120px wide and 90px tall. The default thumbnail
     for a channel is 88px wide and 88px tall.
     - medium – A higher resolution version of the thumbnail image. For a video
     (or a resource that refers to a video), this image is 320px wide and
     180px tall. For a channel, this image is 240px wide and 240px tall.
     - high – A high resolution version of the thumbnail image. For a video (or
     a resource that refers to a video), this image is 480px wide and
     360px tall. For a channel, this image is 800px wide and 800px tall.
     - standard – An even higher resolution version of the thumbnail image than
     the high resolution image. This image is available for some videos
     and other resources that refer to videos, like playlist items or
     search results. This image is 640px wide and 480px tall.
     - maxres – The highest resolution version of the thumbnail image. This
     image size is available for some videos and other resources that
     refer to videos, like playlist items or search results. This image
     is 1280px wide and 720px tall.
     
     - parameter width:   The thumbnails width
     - parameter height:  The thumbnails height
     - parameter rawURL:  The url for the thumnail image. Note that it has escaped
     backslashes.
     - parameter video:   A description of the video
     - parameter context: The managed object context within which to create the
     new object.
     
     - returns: A Thumbnail object.
     */
    
    convenience init(size: String?, width: Int?, height: Int?, rawURL: String?, video: Video,
                     inContext context: NSManagedObjectContext) {
        
        let entityDescription = NSEntityDescription.entityForName(
            "Thumbnail", inManagedObjectContext: context)!
        
        self.init(entity: entityDescription,
                  insertIntoManagedObjectContext: context)
        
        self.video = video
        self.size = size
        self.width = width
        self.height = height
        
        if let rawURL = rawURL {
            self.url = rawURL.stringByReplacingOccurrencesOfString(
                "\\", withString: "")
        }
    }
}
