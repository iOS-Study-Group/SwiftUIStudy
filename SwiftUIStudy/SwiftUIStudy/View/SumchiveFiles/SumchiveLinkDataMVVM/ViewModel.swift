//
//  ScData_ViewModel.swift
//  SwiftUIStudy
//
//  Created by 김수민 on 7/24/24.
//

import Foundation

class ScData_ViewModel: ObservableObject {

    @Published var picsumPhotos: [PicsumPhoto] = []
    @Published var isLoading = false
    

    func getJsonFile() async throws {
        
        //데이터 로딩중..
        isLoading = true

        defer { isLoading = false }
        //defer은 함수가 끝나면 실행됨
        //데이터 로딩 끝나면 isLoading false로 변경

        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://picsum.photos/v2/list")!)
        //URLSession.shared.data(from:) : url에서 데이터 가져옴(비동기적)
        
        
        self.picsumPhotos = try JSONDecoder().decode([PicsumPhoto].self, from: data).shuffled()
        //JSONDecoder().decode([PicsumPhoto].self, from: data) : 가져온 json 데이터를 배열로 디코딩하고 무작위로 섞기
    }
}
