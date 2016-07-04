//
//  PNSClient.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 6/30/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

/* This is where all network request should be happening. The networking to get the videos from youtube and the requests for the thumbnail */

class PNSClient: NSObject {
    
    let dataHelper = DataHelper.sharedInstance
    
    var videoArray = [Video]()
    
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
                var arrayOfVideos = [Video]()
            }
        }
    }
    //create a thumbnail
    func createThumbnail() {
        let videoThumbnailUrlString = "https://i.ytimg.com/vi/" + videoId + "/hqdefault.jpg"
        
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
    
    class var sharedInstance: PNSClient {
        struct Singleton {
            static let instance: PNSClient = PNSClient()
        }
        return Singleton.instance
    }
    
}// End of class