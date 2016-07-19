//
//  PNSTwitterController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 5/23/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import MaterialKit

class PNSTwitterController: UIViewController {
    
    @IBOutlet weak var connectWithUs: UILabel!
    @IBOutlet weak var popNutshellBtn: MKButton!
    @IBOutlet weak var anthonyBtn: MKButton!
    @IBOutlet weak var malcolmBtn: MKButton!
    @IBOutlet weak var dylanBtn: MKButton!
    @IBOutlet weak var willieBtn: MKButton!
    @IBOutlet weak var patrickBtn: MKButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func connectWithPNS(sender: UIButton) {
        let button = MKButton(frame: CGRect(x: 20, y: 141, width: 560, height: 40))
        button.maskEnabled = true
        button.rippleLayerColor = UIColor.darkGrayColor()
        
        
        let twURL: NSURL = NSURL(string: "twitter://user?screen_name=popnutshell")!
        let twURLWeb: NSURL = NSURL(string: "https://twitter.com/popnutshell?s=09")!
        
        if(UIApplication.sharedApplication().canOpenURL(twURL)) {
            UIApplication.sharedApplication().openURL(twURL)
        } else {
            UIApplication.sharedApplication().openURL(twURLWeb)
        }
    }
    
    @IBAction func connectWithAnthony(sender: UIButton) {
        let button = MKButton(frame: CGRect(x: 20, y: 141, width: 560, height: 40))
        button.maskEnabled = true
        button.rippleLayerColor = UIColor.darkGrayColor()
        
        let twURL: NSURL = NSURL(string: "twitter://user?screen_name=AnthonyPitalo")!
        let twURLWeb: NSURL = NSURL(string: "https://twitter.com/AnthonyPitalo?s=09")!
        
        if(UIApplication.sharedApplication().canOpenURL(twURL)) {
            UIApplication.sharedApplication().openURL(twURL)
        } else {
            UIApplication.sharedApplication().openURL(twURLWeb)
        }
    }
    
    @IBAction func connectWithMalcolm(sender: UIButton) {
        let button = MKButton(frame: CGRect(x: 20, y: 141, width: 560, height: 40))
        button.maskEnabled = true
        button.rippleLayerColor = UIColor.darkGrayColor()
        
        let twURL: NSURL = NSURL(string: "twitter://user?screen_name=AniMalcolm79")!
        let twURLWeb: NSURL = NSURL(string: "https://twitter.com/AniMalcolm79?s=09")!
        
        if(UIApplication.sharedApplication().canOpenURL(twURL)) {
            UIApplication.sharedApplication().openURL(twURL)
        } else {
            UIApplication.sharedApplication().openURL(twURLWeb)
        }
    }
    
    @IBAction func connectWithDylan(sender: UIButton) {
        let button = MKButton(frame: CGRect(x: 20, y: 141, width: 560, height: 40))
        button.maskEnabled = true
        button.rippleLayerColor = UIColor.darkGrayColor()
        
        let twURL: NSURL = NSURL(string: "twitter://user?screen_name=TheRealDill2112")!
        let twURLWeb: NSURL = NSURL(string: "https://twitter.com/TheRealDill2112?s=09")!
        
        if(UIApplication.sharedApplication().canOpenURL(twURL)) {
            UIApplication.sharedApplication().openURL(twURL)
        } else {
            UIApplication.sharedApplication().openURL(twURLWeb)
        }
    }
    
    @IBAction func connectWithWillie(sender: UIButton) {
        let button = MKButton(frame: CGRect(x: 20, y: 141, width: 560, height: 40))
        button.maskEnabled = true
        button.rippleLayerColor = UIColor.darkGrayColor()

        let twURL: NSURL = NSURL(string: "twitter://user?screen_name=willmcg7")!
        let twURLWeb: NSURL = NSURL(string: "https://twitter.com/willmcg7?s=09")!
        
        if(UIApplication.sharedApplication().canOpenURL(twURL)) {
            UIApplication.sharedApplication().openURL(twURL)
        } else {
            UIApplication.sharedApplication().openURL(twURLWeb)
        }
    }
    
    @IBAction func connectWithPatrick(sender: UIButton) {
        let button = MKButton(frame: CGRect(x: 20, y: 141, width: 560, height: 40))
        button.maskEnabled = true
        button.rippleLayerColor = UIColor.darkGrayColor()

        let twURL: NSURL = NSURL(string: "twitter://user?screen_name=pbellot")!
        let twURLWeb: NSURL = NSURL(string: "https://twitter.com/pbellot?s=09")!
        
        if(UIApplication.sharedApplication().canOpenURL(twURL)) {
            UIApplication.sharedApplication().openURL(twURL)
        } else {
            UIApplication.sharedApplication().openURL(twURLWeb)
        }
    }
} // End of Class