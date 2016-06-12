//
//  VideoModel.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 4/27/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import Alamofire

protocol VideoModelDelegate {
    func dataReady()
}

class VideoModel: NSObject {
    
    let API_KEY = "AIzaSyD4vD0hzDQb_6YZ5e8c74RqxT7-Mc0Vb2o"
    let UPLOADS_PLAYLIST_ID = "UUFVIFIL74C2zW-9tABzKCAg"
    let URL = "https://www.googleapis.com/youtube/v3/playlistItems"
    let maxResults = 50
    
    var videoArray = [Video]()
    var delegate: VideoModelDelegate?

    
    func getFeedVideos() {
        
        // Fetch the videos dynamically through the YouTube Data API
        Alamofire.request(.GET, URL, parameters: ["part": "snippet", "playlistId": UPLOADS_PLAYLIST_ID, "key": API_KEY, "maxResults": maxResults], encoding: .URL, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let response = JSON as! NSDictionary
                let userID = response.objectForKey("items")
                print(userID)
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
        }
        
            if let JSON = response.result.value {
                
                var arrayOfVideos = [Video]()
                
                for video in JSON["items"] as! NSArray {
                    print(video)
                
                let videoObj = Video()
                videoObj.videoId = video.valueForKeyPath("snippet.resourceId.videoId") as! String
                videoObj.videoTitle = video.valueForKeyPath("snippet.title") as! String
                videoObj.videoDescription = video.valueForKeyPath("snippet.description") as! String
                    if let highUrl = video.valueForKeyPath("snippet.thumbnails.high.url") as? String {
                        videoObj.videoThumbnailUrl = highUrl
                    }
                
                arrayOfVideos.append(videoObj)
                
            }
            
            // When all the video objects have been constructed, assign the array to the VideoModel property
            self.videoArray = arrayOfVideos
            
            // Notify the dlegate that the data is ready
            if self.delegate != nil {
                self.delegate!.dataReady()
            }
         }
       }
    }
   } // End of Class
