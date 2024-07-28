//
//  SoomPhotoModel.swift
//  SwiftUIStudy
//
//  Created by Soom on 7/24/24.
//

import Foundation


struct SoomPhotoModel: Codable, Identifiable{
    let id, author: String
    let width, height: Int
    let url, downloadURL: String
    
    var x: CGFloat = 0
    var y: CGFloat = 0

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
    static let dummyData = SoomPhotoModel(id: "0", author: "몰루", width: 0, height: 0, url: "google.com", downloadURL: "google.com", x: 0, y: 0)
}
