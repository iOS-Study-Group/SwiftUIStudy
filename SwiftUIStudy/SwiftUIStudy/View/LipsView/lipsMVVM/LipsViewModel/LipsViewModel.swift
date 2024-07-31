//
//  LipsViewModel.swift
//  SwiftUIStudy
//
//  Created by wonhoKim on 7/27/24.
//

import Foundation

class LipsViewModel: ObservableObject {
    @Published var images: [ImageData] = [] // 이미지 목록 저장하는 프로퍼티
    
    
    func loadImage() {
        Task {
            do {
                // URL을만듬
                guard let url = URL(string: "https://picsum.photos/v2/list") else {
                    print("URL 생성 불가")
                    return
                }
                
                // 비동기로 requeset를 보냄
                let (data, _) = try await URLSession.shared.data(from: url)
                
                // 결과를 디코딩
                let decoded = try JSONDecoder().decode([ImageData].self, from: data)
                
                //디코딩 된 이미지 목록을 images에 저장 
                DispatchQueue.main.async {
                               self.images = decoded
                           }
                
            } catch {
                print("이미지 로드 에러: \(error.localizedDescription)")
            }
        }
    }
}
