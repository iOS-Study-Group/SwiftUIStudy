//
//  mFetchDataDetailView.swift
//  SwiftUIStudy
//
//  Created by 강승우 on 2024/07/29.
//

import SwiftUI

struct mFetchDataDetailView: View {
    
    var data : mFetchData
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: data.download_url)) { image in
                image.resizable()
                    .frame(width: 400, height: 400)
            } placeholder: {
                Text("\(data.author)")
            }
            Text("author : \(data.author)")
        }
    }
}

//#Preview {
//    mFetchDataDetailView()
//}
