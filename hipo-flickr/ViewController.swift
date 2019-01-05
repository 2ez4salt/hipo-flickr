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
import AlamofireImage

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"FlickrCell") as! FlickrCell
        if self.titleArray.count>0 {
            cell.owner.text=self.titleArray[indexPath.row] as? String
            cell.ownerImage?.image=#imageLiteral(resourceName: "beginner-first-app")
            if let imageUrl = self.photoArray[indexPath.row] as? String{
                Alamofire.request(imageUrl).responseImage(completionHandler: { (response) in
                    print(response)
                    if let image = response.result.value {
                        /*
                         let size = CGSize(width: 1000.0, height: 1000.0)
                         // Scale image to size disregarding aspect ratio
                         let scaledImage = image.af_imageScaled(to: size)
                         */
                        //                        let roundedImage = image.af_imageRounded(withCornerRadius: 100.0)
                        DispatchQueue.main.async {
                            cell.flickrImage?.image = image
                        }
                    }
                })            }
        }
        return cell
        

    }
    
    @IBOutlet weak var tableView: UITableView!


    
    var photos: [Photo] = []
    var photoArray = [Any]()
    var titleArray = [Any]()
 

    
    let url = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=d5f8b2e48bce5c0a4bb35600698f9c03&per_page=3&format=json&nojsoncallback=1&auth_token=72157688390143833-7d5915542fe2c638&api_sig=cadb02a8c5a52cd004b98e7cc399d05a"

    override func viewWillAppear(_ animated: Bool) {
       
        super.viewDidLoad()
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let jsonData : JSON = JSON(response.result.value!)
                for item in jsonData["photos"]["photo"].arrayValue{
                    let secret = item["secret"]
                    let server = item["server"]
                    let owner = item["owner"]
                    let farm = item["farm"]
                    let id = item["id"]
                    var photoUrl: String {
                        return String("https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg")
                        
                    }
                    

                    self.photoArray.append(photoUrl)
                    print(item["owner"])
                    self.titleArray.append(item["title"].string ?? "x")
                    
                }
               // print(self.titleArray)
                print(self.titleArray)
                print(self.photoArray)
                self.tableView?.reloadData()
            }
        }
    }
}

    
 



