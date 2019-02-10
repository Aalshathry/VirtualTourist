//
//  APIConstants.swift
//  Virtual Tourist
//
//  Created by Abdulrahman Al Shathry on 01/06/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation

struct APIConstants {
    
    static let BASE = "https://api.flickr.com/services/rest"
    static let API_KEY = "9766213ad7ddf2c335e458a6c759e304"
    
    struct ParameterKeys {
        static let KEY = "api_key"
        static let METHOD = "method"
        static let FORMAT = "format"
        static let LATITUDE = "lat"
        static let LONGITUDE = "lon"
        static let TAGS = "tags"
        static let PER_PAGE = "per_page"
        static let ACCURCY = "accuracy"
        static let CALL_BACK = "nojsoncallback"
    }
}

