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
    
    var videoArray = [PNSVideos]()
    var delegate: VideoModelDelegate?

    func getFeedVideos() {
        
        // Fetch the videos dynamically through the YouTube Data API
        Alamofire.request(.GET, Constants.YouTubeURL, parameters: [Parameters.Part: Parameters.Snippet, Parameters.PlaylistId: Constants.UPLOADS_PLAYLIST_ID, Parameters.Key: Constants.API_KEY, Parameters.MaxResults : 50], encoding: .URL, headers: nil).responseJSON { (response) in
            
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
                
                var arrayOfVideos = [PNSVideos]()
                
                for video in JSON["items"] as! NSArray {
                    print(video)
                
                let videoObj = PNSVideos()
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
