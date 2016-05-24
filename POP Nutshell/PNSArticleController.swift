//
//  PNSArticleController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 5/24/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit

class PNSArticleController: UIViewController {
    
    @IBOutlet weak var articleView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = "http://www.popnutshell.com/articles.html"
        let requestUrl = NSURL(string: url)
        let request = NSURLRequest(URL: requestUrl!)
        articleView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
} // End of Class