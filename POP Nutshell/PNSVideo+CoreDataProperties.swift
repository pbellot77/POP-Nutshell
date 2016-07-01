//
//  PNSVideos.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 4/27/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import Foundation
import CoreData

extension Video {
    
    @NSManaged var videoId: String?
    @NSManaged var videoTitle: String?
    @NSManaged var videoThumbnail: String?
    @NSManaged var videoDescription: String?
    @NSManaged var isFavorite: Bool
}