//
//  ViewController.swift
//  hipo-flickr
//
//  Created by Talha Salt on 30.12.2018.
//  Copyright © 2018 Talha Salt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    var photoArray = [Any]()
    var array = [Any]()
    let url = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=ac3cf133f7f530a931a5910384ce3c25&per_page=10&format=json&nojsoncallback=1"

    override func viewDidLoad() {
        super.viewDidLoad()
            getRecentPhotos()
        }
    
    
    func getRecentPhotos(){
        AF.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let jsonData : JSON = JSON(response.result.value!)
                for item in jsonData["photos"]["photo"].arrayValue {
                    let secret = item["secret"]
                    let server = item["server"]
                    let owner = item["owner"]
                    let farm = item["farm"]
                    let title = item["title"]
                    let id = item["id"]
                    var photoUrl: NSURL {
                        return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
                    }
                    
                    // Flickr image url pattern is "https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg"

                    self.array.append(secret)
                    print(self.array)
                    
                    print("secret = ", secret, "\n" ,"owner = ", owner , "\n" , "farm = ", farm, "\n", "title = ", title, "\n", "id = ", id ,"\n","photoUrl = ", photoUrl)
                    
                    print("##########################################################################")
                }
                
                
            } else {
                print("Error: \(String(describing: response.result.error))")
            }
        }
        }
    }
    
    




