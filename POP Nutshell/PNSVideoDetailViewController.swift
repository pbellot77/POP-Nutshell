//
//  PNSVideoDetailViewController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 5/2/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import ReachabilitySwift

class PNSVideoDetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    
    var selectedVideo: Video?
    var reachability: Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                if reachability.isReachableViaWiFi() {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                print("Not reachable")
                let alert = UIAlertController(title: "Internet Unavailable",
                                              message: "Try again when connected to the Internet",
                                              preferredStyle: .Alert)
                let tryAction = UIAlertAction(title: "Try Again", style: .Default) {(action) -> Void in
                    print("You selected Try Again")
                    self.webView.reload()
                }
                
                let okAction = UIAlertAction(title: "OK", style: .Default) { (alert) -> Void in
                    print("You selected OK")
                }
                
                alert.addAction(tryAction)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        reachability.stopNotifier()
        webView.reload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let vid = selectedVideo {
            
            titleLabel.text = vid.title
            descriptionLabel.text = vid.videoDescription
            
            let width = self.view.frame.size.width
            let height = width/320 * 180
            let videoId: String = vid.videoId!
            
            // Adjust the height of the webView constraint
            self.webViewHeightConstraint.constant = height
            
            let videoEmbedString = "<html><head><style type=\"text/css\">body {background-color:transparent;color: white;}</style></head><body style=\"margin:0\"><iframe frameBorder=\"0\" height=\"" + String(height) + "\" width=\"" + String(width) + "\" src=\"http://www.youtube.com/embed/" + (videoId) + "?showinfo=0&modestbranding=1&frameborder=0&rel=0\"></iframe></body></html>"
            
            webView.loadHTMLString(videoEmbedString, baseURL: nil)
        }
    }
}// End of Class

