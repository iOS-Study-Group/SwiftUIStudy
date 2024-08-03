//
//  mDataManager.swift
//  SwiftUIStudy
//
//  Created by 강승우 on 2024/07/24.
//

import Foundation

enum fetchError : Error {
    case initError
    case URLError
}

class mFetchDataManager : ObservableObject {
    @Published var datas : [mFetchData] = []
    @Published var printCon : Any?
    let urlAddress : String = "https://picsum.photos/v2/list"
    
    func fetchData() {
            guard let url = URL(string: urlAddress) else {
                print("URL Error")
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }
                
                guard let data = data else { return}
                
                do {
                    let datas = try JSONDecoder().decode([mFetchData].self, from: data)
                    DispatchQueue.main.async {
                        self.datas = datas
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }.resume()
        }
}
