//
//  YouTubeClient.swift
//  POP Nutshell
//
//  Created by Patrick Bellot and Andy Bargh https://www.andybargh.com on 6/14/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public enum Result<T> {
    case Success(T)
    case Failure(ErrorType)
}

struct Constants {
        
    static let APIKey = "AIzaSyD4vD0hzDQb_6YZ5e8c74RqxT7-Mc0Vb2o"
    static let UploadsPlaylistId = "UUFVIFIL74C2zW-9tABzKCAg"
    static let YouTubeURL = "https://www.googleapis.com/youtube/v3/playlistItems"
}
    
struct Parameters {
        
    static let Part = "part"
    static let Snippet = "snippet"
    static let PlaylistId = "playlistId"
    static let Key = "key"
    static let MaxResults = "maxResults"
    static let Resolution = "high"
    
}

class YouTubeService {
    
    internal func fetchData(completionHandler completion: Result<JSON> -> Void) {
        
        Alamofire.request(.GET,
            Constants.YouTubeURL,
            parameters: [
                Parameters.Part : Parameters.Snippet,
                Parameters.PlaylistId : Constants.UploadsPlaylistId,
                Parameters.Key : Constants.APIKey,
                Parameters.MaxResults : 50],
            encoding: .URL,
            headers: nil).validate().responseJSON { (response) -> Void in
                
                guard response.result.isSuccess else {
                    print("Error while fetching YouTube videos: \(response.result.error)")
                    completion(Result<JSON>.Failure(response.result.error!))
                    return
                }
                
                guard let value = response.result.value as? [String: AnyObject] else {
                    print("Malformed data received")
                    return
                }
                
                completion(Result<JSON>.Success(JSON(value)))
        }
    }    
}