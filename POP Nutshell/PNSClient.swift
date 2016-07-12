//
//  PNSClient.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 6/30/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//


import UIKit
import Alamofire
import CoreData

protocol FetchResultsControllerDelegate {
    func dataReady()
}

class PNSClient: NSObject {
    
    var pnsVideos = [Video]()
    var delegate: FetchResultsControllerDelegate?
    let coreDataStack = CoreDataStack.sharedInstance
    
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
                
                let entity = NSEntityDescription.entityForName("Video", inManagedObjectContext: self.coreDataStack.context)
                
                var arrayOfPNSVideos = [Video]()
                
                for video in JSON["items"] as! NSArray {
                    print(video)
                    
                    let videoId = video.valueForKeyPath("snippet.resourceId.videoId") as? String
                    let videoTitle = video.valueForKeyPath("snippet.title") as? String
                    let videoDescription = video.valueForKeyPath("snippet.description") as? String
                    if let highUrl = video.valueForKeyPath("snippet.thumbnails.high.url") as? String {
                        let videoThumbnailUrl = highUrl
                        
                    let video = Video(entity: entity!, insertIntoManagedObjectContext: self.coreDataStack.context)
                        
                    video.videoId = videoId
                    video.videoTitle = videoTitle
                    video.videoDescription = videoDescription
                    video.videoThumbnailUrl = videoThumbnailUrl
                }
                
                self.pnsVideos = arrayOfPNSVideos
                    
                if self.delegate != nil {
                    self.delegate?.dataReady()
                    }
            }
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