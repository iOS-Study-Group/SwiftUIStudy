//
//  ScDataModel.swift
//  SwiftUIStudy
//
//  Created by 김수민 on 7/24/24.
//
/*
 {
 "id": "0",
 "author": "Alejandro Escamilla",
 "width": 5000,
 "height": 3333,
 "url": "https://unsplash.com/photos/yC-Yzbqy7PY",
 "download_url": "https://picsum.photos/id/0/5000/3333"
 }
 */
import Foundation

struct PicsumPhoto: Codable, Identifiable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
}
