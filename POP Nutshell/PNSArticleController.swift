//
//  PNSArticleController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 5/24/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import ReachabilitySwift

class PNSArticleController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var articleView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var reachability: Reachability?
    
    override func viewWillAppear(animated: Bool) {
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PNSViewController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
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
                                              message: "Try again when connected to the Internet",
                                              preferredStyle: .ActionSheet)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (alert) in
                    exit(0)
                })
                
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        reachability.stopNotifier()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "http://www.popnutshell.com/articles.html"
        let requestUrl = NSURL(string: url)
        let request = NSURLRequest(URL: requestUrl!)
        articleView.loadRequest(request)
        articleView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        articleView.reload()
    }
} // End of Class