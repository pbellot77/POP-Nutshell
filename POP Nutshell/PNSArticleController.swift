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

        let url = VideoModel.Constants.POPNutshellURL
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