//
//  LinkData.swift
//  SwiftUIStudy
//
//  Created by 이소영 on 7/23/24.
//

import Foundation

enum GettingError: Error {
    case urlError
    case urlSeesionError
}

struct LinkData {
    var address: String = "https://picsum.photos/v2/list"
    var isSuccess: Bool = false
    var result: String = ""
    var jsonDatas: [JsonData] = []
}

struct JsonData: Identifiable {
    var uuid: UUID = UUID()
    var id: String = ""
    var author: String = ""
    var width: Int = 0
    var height: Int = 0
    var url: String = ""
    var download_url: String = ""
}
