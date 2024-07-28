//
//  mFetchData.swift
//  SwiftUIStudy
//
//  Created by 강승우 on 2024/07/24.
//

import Foundation

struct mFetchDatas : Codable {
    let datas : [mFetchData]
    
    enum CodingKeys: String, CodingKey {
        case datas = "data"
    }
}

struct mFetchData : Codable{
    var id: String
    var author: String
    var width: Int
    var height: Int
    var url: String
    var download_url: String
}

