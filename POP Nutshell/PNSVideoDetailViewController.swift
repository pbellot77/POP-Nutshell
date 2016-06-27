//
//  PNSVideoDetailViewController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 5/2/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit

class PNSVideoDetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    

    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    
    var selectedVideo: PNSVideos?
    //var currentVideo: Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let vid = selectedVideo {
            
            titleLabel.text = vid.videoTitle
            descriptionLabel.text = vid.videoDescription
            
            let width = self.view.frame.size.width
            let height = width/320 * 180
            
            // Adjust the height of the webView constraint
            self.webViewHeightConstraint.constant = height
            
            let videoEmbedString = "<html><head><style type=\"text/css\">body {background-color:transparent;color: white;}</style></head><body style=\"margin:0\"><iframe frameBorder=\"0\" height=\"" + String(height) + "\" width=\"" + String(width) + "\" src=\"http://www.youtube.com/embed/" + vid.videoId + "?showinfo=0&modestbranding=1&frameborder=0&rel=0\"></iframe></body></html>"
            
            self.webView.loadHTMLString(videoEmbedString, baseURL: nil)
        }
        
//        if let favVid = currentVideo {
//            
//            titleLabel.text = favVid.videoTitle
//            descriptionLabel.text = favVid.videoDescription
//            
//            let width = self.view.frame.size.width
//            let height = width/320 * 180
//            
//            // Adjust the height of the webView constraint
//            self.webViewHeightConstraint.constant = height
//            
//            let videoEmbedString = "<html><head><style type=\"text/css\">body {background-color:transparent;color: white;}</style></head><body style=\"margin:0\"><iframe frameBorder=\"0\" height=\"" + String(height) + "\" width=\"" + String(width) + "\" src=\"http://www.youtube.com/embed/" + favVid.videoId + "?showinfo=0&modestbranding=1&frameborder=0&rel=0\"></iframe></body></html>"
//            
//            self.webView.loadHTMLString(videoEmbedString, baseURL: nil)
//
//        }
    }
}// End of Class

