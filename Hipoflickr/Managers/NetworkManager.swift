//
//  NetworkManager.swift
//  Hipoflickr
//
//  Created by Efe Helvacı on 23.04.2017.
//  Copyright © 2017 Efe Helvacı. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager : NSObject {
    // Network Manager is a singleton
    static let sharedInstance = NetworkManager()
    private override init() {}
    
    let api_key     = "bbb3c611d71607522c5ce8322f0fed99"
    let per_page    = 20
    let res_format  = "json"
    let baseURL     = "https://api.flickr.com/services/rest/?"
    
    // Retrieve images from Flickr API
    func retrieveFlicks(text: String?, page: Int, completion: @escaping ([Flick]) -> Void) -> Void {
        let fullURL : String
        
        // If text parameter is not nil then it's a Search query
        // Else it will get recent images
        if text != nil {
            let method  = "flickr.photos.search"
            fullURL     = baseURL + "method=\(method)&" + "api_key=\(api_key)&" + "per_page=\(per_page)&" + "page=\(page)&" + "format=\(res_format)&" + "extras=date_taken&" + "text=\(text!)&" + "nojsoncallback=1"
        } else {
            let method  = "flickr.photos.getRecent"
            fullURL     = baseURL + "method=\(method)&" + "api_key=\(api_key)&" + "per_page=\(per_page)&" + "page=\(page)&" + "format=\(res_format)&" + "extras=date_taken&" + "nojsoncallback=1"
        }
        
        var flicks = [Flick]()
        
        Alamofire.request(fullURL).responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error : Error while retrieving images from URL = \(fullURL)")
                completion(flicks)
                return
            }
            
            guard let responseData = response.data else {
                print("Error : Data that recieved from Flickr API is not valid.")
                completion(flicks)
                return
            }
            
            let json = JSON(data: responseData)
            if let imagesArray = json["photos"]["photo"].array {
                for image in imagesArray {
                    let _flick = Flick(json: image)
                    
                    // Owner of the image is requesting from API using image owner ID
                    self.retrieveOwner(id: image["owner"].stringValue, completion: { (owner) in
                        _flick.owner = owner
                    })
                    
                    flicks.append(_flick)
                }
            }
            
            completion(flicks)
        }
    }
    
    // Retrieve image owners data from Flickr API
    func retrieveOwner(id: String, completion: @escaping (Profile?) -> Void ) -> Void {
        let method = "flickr.people.getInfo"
        let fullURL = baseURL + "method=\(method)&" + "api_key=\(api_key)&" + "user_id=\(id)&" + "format=\(res_format)" + "&nojsoncallback=1"
        
        Alamofire.request(fullURL).responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error : Error while retrieving profile from URL = \(fullURL)")
                completion(nil)
                return
            }
            
            guard let responseData = response.data else {
                print("Error : Data that recieved from Flickr API is not valid.")
                completion(nil)
                return
            }
            
            let json = JSON(data: responseData)
            let profile = Profile(json: json)
            
            completion(profile)
        }
    }
    
    
}
