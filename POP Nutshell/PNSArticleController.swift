//
//  PNSArticleController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 5/24/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit

class PNSArticleController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var articleView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        let alert = UIAlertController(title: "Internet Unavailable",
                                      message: "Try again when connected to the Internet",
                                      preferredStyle: .Alert)
        let tryAction = UIAlertAction(title: "Try Again", style: .Default) {(action) -> Void in
            print("You selected Try Again")
        }
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { (alert) -> Void in
            print("You selected OK")
            exit(0)
        }
        
        alert.addAction(tryAction)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
        activityIndicator.hidden = true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        articleView.reload()
    }
} // End of Class