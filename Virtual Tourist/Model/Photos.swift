//
//  Photos.swift
//  Virtual Tourist
//
//  Created by Abdulrahman Al Shathry on 01/06/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation

struct Photos: Codable {
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: Int?
    var photo: photo
}

struct photo: Codable {
    var id: Int?
    var owner: String?
    var secret: String?
    var server: Int?
    var farm: Int?
    var title: String?
    var ispublic: Int?
    var isfriend: Int?
    var isfamily: Int?
}
