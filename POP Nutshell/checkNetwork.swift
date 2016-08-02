//
//  checkNetwork.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 8/2/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import ReachabilitySwift
import UIKit

class CheckNetwork {
    
    func hasConnectivity() -> Bool {
        do {
            let reachability: Reachability = try Reachability.reachabilityForInternetConnection()
            let networkStatus: Int = reachability.currentReachabilityStatus.hashValue
            print(networkStatus)
            
            return (networkStatus != 0)
        } catch {
            let alert = UIAlertController(title: "Internet Unavailable",
                                          message: "Try again when connected to the Internet",
                                          preferredStyle: .ActionSheet)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (alert) in
                exit(0)
            })
            alert.addAction(okAction)
            
            return false
        }
    }
}