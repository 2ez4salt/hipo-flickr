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
    
    var image: String?
    var owner: String?
    var imageOwner : String?
    
    
    init(image: String, owner: String, imageOwner:String) {
        self.image = image
        self.imageOwner = imageOwner
        self.owner = owner
    }
}
