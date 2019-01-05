//
//  FlickrCell.swift
//  hipo-flickr
//
//  Created by Talha Salt on 3.01.2019.
//  Copyright © 2019 Talha Salt. All rights reserved.
//

import UIKit

class FlickrCell: UITableViewCell {

    @IBOutlet weak var ownerImage: UIImageView?
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var flickrImage: UIImageView!
    

        
  //  }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
