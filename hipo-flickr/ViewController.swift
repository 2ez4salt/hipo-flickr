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

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
  
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.photoArray.removeAll()
        self.profilePhotoArray.removeAll()
        self.ownerArray.removeAll()
        self.titleArray.removeAll()
        let tags = searchBar.text
        let finaltags = tags?.replacingOccurrences(of: " ", with: "+")
        
        let SearchUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=a7a564b411d3c9fb8341e8a74c3da9b8&tags=\(finaltags!)&extras=owner_name%2C+icon_server%2C+date_upload&per_page=5&format=json&nojsoncallback=1"
        Alamofire.request(SearchUrl, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let jsonData : JSON = JSON(response.result.value!)
                for item in jsonData["photos"]["photo"].arrayValue{
                    var secret = item["secret"]
                    var server = item["server"]
                    var owner = item["owner"]
                    var farm = item["farm"]
                    var id = item["id"]
                    var iconfarm = item["iconfarm"]
                    var iconserver = item["iconserver"]
                    var photoUrl: String {
                        return String("https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg")
                    }
                    print(photoUrl)
                    var ProfilePhotoUrl:String{
                        return String("https://farm\(iconfarm).staticflickr.com/\(iconserver)/buddyicons/\(owner).jpg")
                    }
                   
                    self.photoArray.append(photoUrl)
                    self.profilePhotoArray.append(ProfilePhotoUrl)
                    self.ownerArray.append(item["ownername"].string ?? "x")
                    self.titleArray.append(item["title"].string ?? "x")
                }
       
                self.tableView?.reloadData()
}
        }
        
        print(SearchUrl)
        self.view.endEditing(true)
}
   
    
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
                            cell.ownerImage?.image = image.af_imageRoundedIntoCircle()
                        }
                    }
                })            }
            cell.ownerImage?.image=#imageLiteral(resourceName: "profile-42914_960_720").af_imageRoundedIntoCircle() // if user hasnt profile photo !!
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

    
    let url = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=4076cafc4e9cdbe04daefd31930edeb0&extras=owner_name%2C+icon_server%2C+date_upload&per_page=2&format=json&nojsoncallback=1"
    func getPhotos(){
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let jsonData : JSON = JSON(response.result.value!)
                for item in jsonData["photos"]["photo"].arrayValue{
                    var secret = item["secret"]
                    var server = item["server"]
                    var owner = item["owner"]
                    var farm = item["farm"]
                    var id = item["id"]
                    var iconfarm = item["iconfarm"]
                    var iconserver = item["iconserver"]
                    var photoUrl: String {
                        return String("https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg")
                    }
                    print(photoUrl)
                    var ProfilePhotoUrl:String{
                        return String("https://farm\(iconfarm).staticflickr.com/\(iconserver)/buddyicons/\(owner).jpg")
                    }
                    self.photoArray.append(photoUrl)
                    self.profilePhotoArray.append(ProfilePhotoUrl)
                    self.ownerArray.append(item["ownername"].string ?? "x")
                    self.titleArray.append(item["title"].string ?? "x")
                }
                self.tableView?.reloadData()
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       getPhotos()
        searchBar.delegate = self
    }
    
    }

