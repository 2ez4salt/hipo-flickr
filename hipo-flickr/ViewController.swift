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
    var photos: [Photo] = []
    var array = [Any]()
    var photoArray = [Any]()
   
 
    func createArray() -> [Photo] {
        
            
        let Photo1 = Photo(image: #imageLiteral(resourceName: "ss-delegates"), owner: "sad", imageOwner:#imageLiteral(resourceName: "beginner-first-app"))
        let Photo2 = Photo(image: #imageLiteral(resourceName: "dev-setup"), owner: "My Dev Setup",imageOwner:#imageLiteral(resourceName: "vlog-4"))
        let Photo3 = Photo(image: #imageLiteral(resourceName: "int-overview"), owner: "iOS Interview",imageOwner:#imageLiteral(resourceName: "vlog-4"))
        let Photo4 = Photo(image: #imageLiteral(resourceName: "ss-delegates"), owner: "Buttons in TableViews",imageOwner:#imageLiteral(resourceName: "vlog-4"))
        let Photo5 = Photo(image: #imageLiteral(resourceName: "ss-uipickerview-card"), owner: "UIPickerView Tutorial",imageOwner:#imageLiteral(resourceName: "vlog-4"))
        let Photo6 = Photo(image: #imageLiteral(resourceName: "vlog-4"), owner: "Day in the Life",imageOwner:#imageLiteral(resourceName: "vlog-4"))

        return [Photo1 , Photo2, Photo3, Photo4, Photo5, Photo6]
        
    }
    
  


  
    
    
    let url = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=a608cc5753c3c359bc5093114353187f&per_page=3&format=json&nojsoncallback=1&auth_token=72157699430634970-0555dd9609accacc&api_sig=3d4ff3b0c2ca83ae46410983c9482b83"

    override func viewDidLoad() {
        super.viewDidLoad()
        getRecentPhotos()
        photos = createArray()
        }
    
    
    func getRecentPhotos(){
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let jsonData : JSON = JSON(response.result.value!)
                print(jsonData)
                for item in jsonData["photos"]["photo"].arrayValue {
                    let secret = item["secret"]
                    let server = item["server"]
                    let owner = item["owner"]
                    let farm = item["farm"]
                    let title = item["title"]
                    let id = item["id"]
                    // Flickr image url pattern = "https://farm{farm-id}.staticflickr.com/{server-id}/{id} _{secret}_[mstzb].jpg"
                    var photoUrl: NSURL {
                        return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
                    
                    }
                     self.array.append(photoUrl)
                  //  self.array.append(secret)
                 //   self.array.append(server)
                   self.array.append(owner)
                  //  self.array.append(farm)
                   self.array.append(title)
                 //   self.array.append(id)
                  
                    
                
                    print("secret = ", secret, "\n" ,"owner = ", owner , "\n" , "farm = ", farm, "\n", "title = ", title, "\n", "id = ", id ,"\n","photoUrl = ", photoUrl)
                    
                    print("##########################################################################")
                    
                
                }
            self.photoArray.append(self.array)
                print(self.photoArray)
                
                
                
                
            } else {
                print("Error: \(String(describing: response.result.error))")
            }
        }
        }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photo = photos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlickrCell") as! FlickrCell
        cell.setPhoto(photo: photo)
        return cell
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
}
