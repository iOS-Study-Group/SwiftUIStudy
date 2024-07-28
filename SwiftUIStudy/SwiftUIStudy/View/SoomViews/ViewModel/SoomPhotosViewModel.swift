//
//  SoomPhotosViewModel.swift
//  SwiftUIStudy
//
//  Created by Soom on 7/24/24.
//

import Foundation
import Observation


@Observable
class SoomPhotosViewModel{
    var photos: [SoomPhotoModel] = []
    let urlString: String = "https://picsum.photos/v2/list"
    let jsonDecoder = JSONDecoder()
    var sortedData: [SoomPhotoModel] = []
    //        get{
    //            return photos.sorted{$0.id < $1.id}
    //        }
    //        set{
    //            self.sortedData = newValue.sorted{$0.id < $1.id}
    //        }
    //    }
    
    init() {
        Task{
            await fetchURL()
        }
    }
    func fetchURL() async{
        guard let url = URL(string: self.urlString) else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let response = response{
            }
            if let error = error{
                print("fetch url error: \(error.localizedDescription)" )
            }
            guard let data = data else{
                return
            }
            do{
                let photoData =  try self.jsonDecoder.decode([SoomPhotoModel].self, from: data)
                DispatchQueue.main.async{
                    self.photos = photoData
                }
            }catch{
                print("디코드 에러: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    func updateCardState(photo: SoomPhotoModel, translation: CGSize) {
        if let index = self.photos.firstIndex(where: { $0.id == photo.id }) {
            photos[index].x = translation.width
            photos[index].y = translation.height
        }
    }
    
    func endDrag(photo: SoomPhotoModel, translation: CGSize) {
        if let index = photos.firstIndex(where: { $0.id == photo.id }) {
            if translation.width > 100 || translation.width < -100 {
                photos.remove(at: index)
            } else {
                photos[index].x = 0
                photos[index].y = 0
            }
        }
    }
}
