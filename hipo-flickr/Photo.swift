//
//  Photo.swift
//  hipo-flickr
//
//  Created by Talha Salt on 3.01.2019.
//  Copyright © 2019 Talha Salt. All rights reserved.
//

import Foundation
import UIKit


class Photo {
    
    var image: UIImage
    var owner: String
    var imageOwner : UIImage
    
    
    init(image: UIImage, owner: String, imageOwner:UIImage) {
        self.image = image
        self.imageOwner = imageOwner
        self.owner = owner
    }
}
