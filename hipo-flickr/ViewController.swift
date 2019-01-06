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
            if let imageUrl = self.profilePhotoArray[indexPath.row] as? String{
                Alamofire.request(imageUrl).responseImage(completionHandler: { (response) in
                    print(response)
                    if let image = response.result.value {
                        DispatchQueue.main.async {
                            cell.ownerImage?.image = image
                        }
                    }
                })            }
            cell.ownerImage?.image=#imageLiteral(resourceName: "profile-42914_960_720") // if user hasnt profile photo !!
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
    var profilePhotoArray = [Any]()
    var titleArray = [Any]()
    var ownerArray = [String]()

    
    let url = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=11be623ab853a1abd2c219f8df6005e6&extras=owner_name%2C+icon_server%2C+date_upload&per_page=10&format=json&nojsoncallback=1&auth_token=72157703965826591-eaf8231e5ecce0d4&api_sig=269494fa0bdda6a8b98da1b9cfb093cc"

    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let jsonData : JSON = JSON(response.result.value!)
                for item in jsonData["photos"]["photo"].arrayValue{
                    print(item)
                    let secret = item["secret"]
                    let server = item["server"]
                    let owner = item["owner"]
                    let farm = item["farm"]
                    let id = item["id"]
                    let iconfarm = item["iconfarm"]
                    let iconserver = item["iconserver"]
                    var photoUrl: String {
                        return String("https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg")
                    }
                    var ProfilePhotoUrl:String{
                        return String("https://farm\(iconfarm).staticflickr.com/\(iconserver)/buddyicons/\(owner).jpg")
                    }
                    self.photoArray.append(photoUrl)
                    self.profilePhotoArray.append(ProfilePhotoUrl)
                    self.ownerArray.append(item["ownername"].string ?? "x")
                    self.titleArray.append(item["title"].string ?? "x")
                }
                self.tableView?.reloadData()
                self.getJSONData()
                for item in self.profilePhotoArray{
                    print(item)
                }
            }
        }
    }
    func getJSONData() {
    
   
        
    }}
