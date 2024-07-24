//
//  SLinkDataView.swift
//  SwiftUIStudy
//
//  Created by 이소영 on 7/23/24.
//

import SwiftUI

struct SLinkDataView: View {
    @ObservedObject var linkDataManager: LinkDataManager = LinkDataManager()
    
    var body: some View {
        Text(linkDataManager.linkData.address)
            .font(.title)
            .fontWeight(.light)
            .padding()
        if linkDataManager.linkData.isSuccess {
            ScrollView() {
                ForEach(linkDataManager.linkData.jsonDatas) {
                    jsonData in
                    ZStack {
                        Rectangle()
                            .fill(Color(.systemGray6))
                
                        VStack {
                            Text("""
                                 {\n
                                 "id": "\(jsonData.id)",\n
                                 "author": "\(jsonData.author)",\n
                                 "width": \(jsonData.width),\n
                                 "height": \(jsonData.height),\n
                                 "url": "\(jsonData.url)",\n
                                 "download_url": "\(jsonData.download_url)"\n
                                 }\n
                                 """)
                        }
                        .padding()
                    }
                }
            }
        } else {
            Text(linkDataManager.linkData.result)
        }
        
        Button("Get link data") {
            Task {
                await linkDataManager.getJSONDataValue()
            }
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    SLinkDataView()
}
