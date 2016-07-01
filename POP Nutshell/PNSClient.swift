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

class PNSClient: NSObject {
    
    class var sharedInstance: PNSClient {
        struct Singleton {
            static let instance: PNSClient = PNSClient()
        }
        return Singleton.instance
    }
    
    let favoritesManager = FavoritesManager.sharedInstance
    
    //Put networking here
    
    //create a thumbnail
    func createThumbnail() {
        
    }
}
