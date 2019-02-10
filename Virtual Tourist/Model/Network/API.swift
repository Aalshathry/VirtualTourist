//
//  API.swift
//  Virtual Tourist
//
//  Created by Abdulrahman Al Shathry on 27/05/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation

class API {
    
    private static var sessionId: String?
    
    static func getImages(_ pin: Pin, completion: @escaping (String?)->Void) {
        guard let url = URL(string: "\(APIConstants.BASE)?\(APIConstants.ParameterKeys.KEY)=\(APIConstants.API_KEY)&\(APIConstants.ParameterKeys.METHOD)=flickr.photos.search&\(APIConstants.ParameterKeys.FORMAT)=json&\(APIConstants.ParameterKeys.LATITUDE)=\(pin.latitude)&\(APIConstants.ParameterKeys.LONGITUDE)=\(pin.longitude)&\(APIConstants.ParameterKeys.TAGS)=&\(APIConstants.ParameterKeys.PER_PAGE)=18&\(APIConstants.ParameterKeys.ACCURCY)=11&\(APIConstants.ParameterKeys.CALL_BACK)=1") else {
            completion(nil)
            return
        }
        let request = URLRequest(url: url)

        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try (JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject])
            } catch {
                print("Could not parse the data as JSON: '\(data!)'")
                return
            }
            
            guard let photosDictionary = parsedResult["photos"] as? [String:AnyObject] else {
                return
            }
            
            guard let photosArray = photosDictionary["photo"] as? [[String: AnyObject]] else {
                return
            }
            
            for index in 0..<photosArray.count {
                let photo = Photo(context: DataController.shared.viewContext)
                let farmID = photosArray[index]["farm"]
                let serverID = photosArray[index]["server"]
                let userID = photosArray[index]["id"]
                let secret = photosArray[index]["secret"]
                
                photo.url = "https://farm\(farmID!).staticflickr.com/\(serverID!)/\(userID!)_\(secret!).jpg"
                photo.pin = pin
                try? DataController.shared.viewContext.save()
                
            }
            var err: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 400{
                    print(statusCode)
                    err = "Error in posting location"
                }
            } else {
                err = "Please check your internet connection"
            }
            DispatchQueue.main.async {
                completion(err)
            }
            
        }
        task.resume()
    }
    
}
