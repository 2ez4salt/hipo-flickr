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
    var appLaunchTime = Date()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var API_KEY = "4076cafc4e9cdbe04daefd31930edeb0"
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.timeArray.removeAll()
        self.newTimeArray.removeAll()
        self.photoArray.removeAll()
        self.profilePhotoArray.removeAll()
        self.ownerArray.removeAll()
        self.titleArray.removeAll()
        let tags = searchBar.text
        let finaltags = tags?.replacingOccurrences(of: " ", with: "+")
        let SearchUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(API_KEY)&tags=\(finaltags!)&extras=owner_name%2C+icon_server%2C+date_taken&per_page=10&format=json&nojsoncallback=1"
        Alamofire.request(SearchUrl, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let jsonData : JSON = JSON(response.result.value!)
                for item in jsonData["photos"]["photo"].arrayValue{
                    print(item)
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
                    self.timeArray.append(item["datetaken"].string ?? "x")

                    for time in self.timeArray{
                        print(time)
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        let date1 = formatter.date(from: time)
                        self.newTimeArray.append(date1!)
                        print(self.newTimeArray)
                    }
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
           cell.DateUploaded.text = newTimeArray[indexPath.row].readbaleDate()

            cell.owner.text=self.ownerArray[indexPath.row] as? String!
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
    var timeArray = [String]()
    var newTimeArray = [Date]()

    
    func getPhotos(){
        var url = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(API_KEY)&extras=owner_name%2C+icon_server%2C+date_taken&date_upload&per_page=10&format=json&nojsoncallback=1"
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                
                let jsonData : JSON = JSON(response.result.value!)
                for item in jsonData["photos"]["photo"].arrayValue{
                    var date_upload = item["datataken"]
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
                    self.timeArray.append(item["datetaken"].string ?? "x")
                    self.profilePhotoArray.append(ProfilePhotoUrl)
                    self.ownerArray.append(item["ownername"].string ?? "x")
                    self.titleArray.append(item["title"].string ?? "x")
                }
                self.tableView?.reloadData()
                for time in self.timeArray{
                    print(time)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

                    let date1 = formatter.date(from: time)
                    self.newTimeArray.append(date1!)
                    print(self.newTimeArray)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Hipo Flickr"
        print(type(of: appLaunchTime))
       getPhotos()
        searchBar.delegate = self
    }
}

extension Date {
    func readbaleDate() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        let value: Int
        let unit: String
        if secondsAgo < minute {
            value = secondsAgo
            unit = "sec"
        } else if secondsAgo < hour {
            value = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            value = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            value = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            value = secondsAgo / week
            unit = "week"
        } else if secondsAgo < year {
            value = secondsAgo / month
            unit = "month"
        } else {
            value = secondsAgo / year
            unit = "year"
        }
        
        return "\(value) \(unit)\(value == 1 ? "" : "s") ago"
}

}
