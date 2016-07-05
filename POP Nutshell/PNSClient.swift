//
//  PNSClient.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 6/30/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//


import UIKit
import Alamofire

class PNSClient: NSObject {
    
    var pnsVideo = Video()
    
    func getFeedVideos() {
        
        // Fetch the videos dynamically through the YouTube Data API
        Alamofire.request(.GET, Constants.YouTubeURL, parameters: [Parameters.Part: Parameters.Snippet, Parameters.PlaylistId: Constants.UPLOADS_PLAYLIST_ID, Parameters.Key: Constants.API_KEY, Parameters.MaxResults : 50], encoding: .URL, headers: nil)
            .validate()
            .responseJSON { (response) -> Void in
            
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
                
                for video in JSON["items"] as! NSArray {
                    print(video)
                    
                    let videoObj = self.pnsVideo
                    videoObj.videoId = video.valueForKeyPath("snippet.resourceId.videoId") as? String
                    videoObj.videoTitle = video.valueForKeyPath("snippet.title") as? String
                    videoObj.videoDescription = video.valueForKeyPath("snippet.description") as? String
                    if let highUrl = video.valueForKeyPath("snippet.thumbnails.high.url") as? String {
                        videoObj.videoThumbnailUrl = highUrl
                }
            }
        }
    }
    //create a thumbnail
    func createThumbnail() {
        let videoThumbnailUrlString = "https://i.ytimg.com/vi/" + pnsVideo.videoId! + "/hqdefault.jpg"
        
        // Create an NSURL object
        if let videoThumbnailUrl = NSURL(string: videoThumbnailUrlString) {
            
            // Create an NSURLRequest object
            let request = NSURLRequest(URL: videoThumbnailUrl)
            
            // Create NSURLSession
            let session = NSURLSession.sharedSession()
            
            // Create a datatask and pass in the request
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    // Get a reference to the image view element of the cell
                    let imageView = cell.image as! UIImageView
                    
                    // Create an image object from the data and assign it into the imageview
                    imageView.image = UIImage(data: data!)
                })
            })
            
            dataTask.resume()
        }
    }
    
    var sharedInstance: PNSClient {
        struct Singleton {
            static let instance: PNSClient = PNSClient()
        }
        return Singleton.instance
    }
}
}// End of class