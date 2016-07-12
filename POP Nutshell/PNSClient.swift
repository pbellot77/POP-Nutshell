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
    
    var pnsVideos = [NSManagedObject]()
    var delegate: FetchResultsControllerDelegate?
    let coreDataStack = CoreDataStack()
    
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
                
                var arrayOfPNSVideos = [Video]()
                
                for video in JSON["items"] as! NSArray {
                    print(video)
                    
                    //let managedContext = self.coreDataStack.managedObjectContext
                    let entity = NSEntityDescription.entityForName("Video", inManagedObjectContext: self.coreDataStack.managedObjectContext)!
                    let videoObj = NSManagedObject(entity: entity, insertIntoManagedObjectContext: self.coreDataStack.managedObjectContext) as! Video
                    
                    videoObj.videoId = videoObj.valueForKeyPath("snippet.resourceId.videoId") as? String
                    videoObj.videoTitle = videoObj.valueForKeyPath("snippet.title") as? String
                    videoObj.videoDescription = videoObj.valueForKeyPath("snippet.description") as? String
                    if let highUrl = videoObj.valueForKeyPath("snippet.thumbnails.high.url") as? String {
                        videoObj.videoThumbnailUrl = highUrl
                    
                        do {
                            try self.coreDataStack.managedObjectContext.save()
                            self.pnsVideos.append(videoObj)
                        } catch let error as NSError {
                            print("Could not save \(error), \(error.userInfo)")
                        }
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