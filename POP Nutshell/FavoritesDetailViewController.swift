//
//  FavoritesDetailViewController.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 6/27/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit

class FavoritesDetailViewController: UIViewController {
    
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    
    var currentVideo: Video?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
       
        if let favVid = currentVideo {
        
        titleLabel.text = favVid.videoTitle
        descriptionLabel.text = favVid.videoDescription
        
        let width = self.view.frame.size.width
        let height = width/320 * 180
        
        // Adjust the height of the webView constraint
        self.webViewHeightConstraint.constant = height
        
        let videoEmbedString =  "<html><head><style type=\"text/css\">body {background-color:transparent;color: white;}</style></head><body style=\"margin:0\"><iframe frameBorder=\"0\" height=\""; "\(height)"; "\" width=\""; "\(width)"; "\" src=\"http://www.youtube.com/embed/"; "\(favVid.videoId)"; "?showinfo=0&modestbranding=1&frameborder=0&rel=0\"></iframe></body></html>"
        
            self.webView.loadHTMLString(videoEmbedString, baseURL: nil)
        
        }
    }
}
