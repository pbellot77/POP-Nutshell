//
//  VideoCell.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 7/3/16.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailUrl: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel!.text = nil
        thumbnailUrl!.image = nil
    }
}
