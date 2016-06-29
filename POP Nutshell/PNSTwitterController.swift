//
//  PNSTwitterController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 5/23/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit

class PNSTwitterController: UIViewController {
    
    @IBOutlet weak var connectWithUs: UILabel!
    @IBOutlet weak var popNutshellBtn: UIButton!
    @IBOutlet weak var anthonyBtn: UIButton!
    @IBOutlet weak var malcolmBtn: UIButton!
    @IBOutlet weak var dylanBtn: UIButton!
    @IBOutlet weak var willieBtn: UIButton!
    @IBOutlet weak var patrickBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func connectWithPNS(sender: UIButton) {
        let twURL: NSURL = NSURL(string: "twitter://user?screen_name=popnutshell")!
        let twURLWeb: NSURL = NSURL(string: "https://twitter.com/popnutshell?s=09")!
        
        if(UIApplication.sharedApplication().canOpenURL(twURL)) {
            UIApplication.sharedApplication().openURL(twURL)
        } else {
            UIApplication.sharedApplication().openURL(twURLWeb)
        }
    }
    
    @IBAction func connectWithAnthony(sender: UIButton) {
        let twURL: NSURL = NSURL(string: "twitter://user?screen_name=AnthonyPitalo")!
        let twURLWeb: NSURL = NSURL(string: "https://twitter.com/AnthonyPitalo?s=09")!
        
        if(UIApplication.sharedApplication().canOpenURL(twURL)) {
            UIApplication.sharedApplication().openURL(twURL)
        } else {
            UIApplication.sharedApplication().openURL(twURLWeb)
        }
    }
    
    @IBAction func connectWithMalcolm(sender: UIButton) {
        let twURL: NSURL = NSURL(string: "twitter://user?screen_name=AniMalcolm79")!
        let twURLWeb: NSURL = NSURL(string: "https://twitter.com/AniMalcolm79?s=09")!
        
        if(UIApplication.sharedApplication().canOpenURL(twURL)) {
            UIApplication.sharedApplication().openURL(twURL)
        } else {
            UIApplication.sharedApplication().openURL(twURLWeb)
        }
    }
    
    @IBAction func connectWithDylan(sender: UIButton) {
        let twURL: NSURL = NSURL(string: "twitter://user?screen_name=TheRealDill2112")!
        let twURLWeb: NSURL = NSURL(string: "https://twitter.com/TheRealDill2112?s=09")!
        
        if(UIApplication.sharedApplication().canOpenURL(twURL)) {
            UIApplication.sharedApplication().openURL(twURL)
        } else {
            UIApplication.sharedApplication().openURL(twURLWeb)
        }
    }
    
    @IBAction func connectWithWillie(sender: UIButton) {
        let twURL: NSURL = NSURL(string: "twitter://user?screen_name=willmcg7")!
        let twURLWeb: NSURL = NSURL(string: "https://twitter.com/willmcg7?s=09")!
        
        if(UIApplication.sharedApplication().canOpenURL(twURL)) {
            UIApplication.sharedApplication().openURL(twURL)
        } else {
            UIApplication.sharedApplication().openURL(twURLWeb)
        }
    }
    
    @IBAction func connectWithPatrick(sender: UIButton) {
        let twURL: NSURL = NSURL(string: "twitter://user?screen_name=pbellot")!
        let twURLWeb: NSURL = NSURL(string: "https://twitter.com/pbellot?s=09")!
        
        if(UIApplication.sharedApplication().canOpenURL(twURL)) {
            UIApplication.sharedApplication().openURL(twURL)
        } else {
            UIApplication.sharedApplication().openURL(twURLWeb)
        }
    }
} // End of Class