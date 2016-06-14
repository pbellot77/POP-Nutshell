//
//  URL.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 6/14/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import Foundation

extension VideoModel {
    
    struct Constants {
        
        static let API_KEY = "AIzaSyD4vD0hzDQb_6YZ5e8c74RqxT7-Mc0Vb2o"
        static let UPLOADS_PLAYLIST_ID = "UUFVIFIL74C2zW-9tABzKCAg"
        static let YouTubeURL = "https://www.googleapis.com/youtube/v3/playlistItems"
    }
    
    struct Parameters {
        
        static let Part = "part"
        static let Snippet = "snippet"
        static let PlaylistId = "playlistId"
        static let Key = "key"
        static let MaxResults = "maxResults"
    }
    
}// End of Class
