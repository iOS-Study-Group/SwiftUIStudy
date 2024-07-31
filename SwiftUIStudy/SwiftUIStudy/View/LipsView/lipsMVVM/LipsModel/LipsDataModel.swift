//
//  LipsDataModel.swift
//  SwiftUIStudy
//
//  Created by wonhoKim on 7/27/24.
//
//"id": "0",
//"author": "Alejandro Escamilla",
//"width": 5000,
//"height": 3333,
//"url": "https://unsplash.com/photos/yC-Yzbqy7PY",
//"download_url": "https://picsum.photos/id/0/5000/3333"
//}

import Foundation
//데이터 모델 정의
//Codable은 Swift에서 데이터의 인코딩과 디코딩을 간편하게 처리할 수 있게 해주는 프로토콜
// codable 은 encode decode로 구성
// encodable: : 객체를 JSON, XML, Property List 등의 포맷으로 인코딩할 수 있게 해주는 프로토콜
// decodable: JSON, XML, Property List 등의 포맷에서 객체를 디코딩할 수 있게 해주는 프로토콜입니다.
struct ImageData: Codable, Identifiable{
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
}
