//
//  FlickrCell.swift
//  hipo-flickr
//
//  Created by Talha Salt on 3.01.2019.
//  Copyright © 2019 Talha Salt. All rights reserved.
//

import UIKit

class FlickrCell: UITableViewCell {

    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var flickrImage: UIImageView!
    
    
    
    func setPhoto(photo: Photo) {
        ownerImage.image = photo.image
        owner.text = photo.owner
        flickrImage.image = photo.image
    }
    
    
    
 // func setVideo(photo: Photo) {
    //    ownerImage.image = photo.image
    //    flickrImage.image = photo.image
        
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
