//
//  PNSArticleController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 5/24/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import ReachabilitySwift

private let url = "http://www.popnutshell.com/articles.html"

class PNSArticleController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var articleView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var reachability: Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        articleView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        articleView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PNSArticleController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
            
            dispatch_async(dispatch_get_main_queue()) {
                print("Internet Unavailable")
                
                let alert = UIAlertController(title: "Internet Unavailable",
                                            message: "Try again when connected to the Internet and refresh",
                                     preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                    print("You selected OK")
                    self.articleView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
                }
                
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        reachability.stopNotifier()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
    }
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        if reachability?.isReachable() == true {
            articleView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                print("Internet Unavailable")
                
                let alert = UIAlertController(title: "Internet Unavailable",
                                            message: "Tap Refresh when connected to the Internet",
                                     preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                    print("You selected OK")
                }
                
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
} // End of Class