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
            cell.owner.text=self.ownerArray[indexPath.row] as? String ?? "No Owner Name Input"
            cell.ownerImage?.image=#imageLiteral(resourceName: "beginner-first-app")
            if let imageUrl = self.photoArray[indexPath.row] as? String{
                Alamofire.request(imageUrl).responseImage(completionHandler: { (response) in
                    print(response)
                    if let image = response.result.value {
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
    var ownerArray = [String]()

    
    let url = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=11be623ab853a1abd2c219f8df6005e6&extras=owner_name%2Cdate_upload&per_page=10&format=json&nojsoncallback=1&auth_token=72157703965826591-eaf8231e5ecce0d4&api_sig=2f294ae2e71bcfa0cf29e0d38ca73f2f"

    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let jsonData : JSON = JSON(response.result.value!)
                for item in jsonData["photos"]["photo"].arrayValue{
                    let secret = item["secret"]
                    let server = item["server"]
                    let owner = item["ownername"]
                    let farm = item["farm"]
                    let id = item["id"]
                    var photoUrl: String {
                        return String("https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg")
                    }
                    self.photoArray.append(photoUrl)
                    self.ownerArray.append(item["ownername"].string ?? "x")
                    self.titleArray.append(item["title"].string ?? "x")
                }
                self.tableView?.reloadData()
                self.getJSONData()

            }
        }
    }
    func getJSONData() {
    
   
        
    }}
