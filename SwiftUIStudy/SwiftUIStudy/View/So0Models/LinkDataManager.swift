//
//  LinkDataManager.swift
//  SwiftUIStudy
//
//  Created by 이소영 on 7/23/24.
//

import Foundation

class LinkDataManager: ObservableObject {
    @Published var linkData: LinkData = LinkData()
    
    func getJSONDataValue() async {
        Task {
            do {
                let data = try await getLinkData()
                
                if let jsons = try JSONSerialization.jsonObject(with: data) as? Array<Dictionary<String, Any>> {
                    for (_, json) in jsons.enumerated() {
                        var jsonData: JsonData = JsonData()
                        if let id = json["id"] as? String {
                            jsonData.id = id
                        }
                        
                        if let author = json["author"] as? String {
                            jsonData.author = author
                        }
                        
                        if let width = json["width"] as? Int {
                            jsonData.width = width
                        }
                        
                        if let height = json["height"] as? Int {
                            jsonData.height = height
                        }
                        
                        if let url = json["url"] as? String {
                            jsonData.url = url
                        }
                        
                        if let download_url = json["download_url"] as? String {
                            jsonData.download_url = download_url
                        }
                        
                        linkData.jsonDatas.append(jsonData)
                        linkData.isSuccess = true
                    }
                }
            } catch GettingError.urlError {
                linkData.result = "URL link Fail"
                linkData.isSuccess = false
            } catch GettingError.urlSeesionError {
                linkData.result = "Link Web Data Fail"
                linkData.isSuccess = false
            } catch {
                linkData.result = "Unknown Error"
                linkData.isSuccess = false
            }
        }
    }
    
    func getLinkData() async throws -> Data {
        guard let url = URL(string: linkData.address) else {
            throw GettingError.urlError
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            print(response)

            return data
        } catch {
            throw GettingError.urlSeesionError
        }
    }
}

