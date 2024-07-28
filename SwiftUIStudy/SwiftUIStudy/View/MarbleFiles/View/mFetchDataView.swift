//
//  mFetchDataView.swift
//  SwiftUIStudy
//
//  Created by 강승우 on 2024/07/24.
//

import SwiftUI

struct mFetchDataView: View {
    @StateObject var dataManager : mFetchDataManager = mFetchDataManager()
    
    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 100))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                Button {
                    dataManager.fetchData()
                } label : {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.blue)
                        .frame(width: 150, height: 40)
                        .overlay {
                            Text("load Images")
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                        }
                }
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(dataManager.datas, id: \.id) {data in
                        NavigationLink {
                            mFetchDataDetailView(data : data)
                        } label: {
                            VStack(alignment: .leading) {
                                AsyncImage(url: URL(string: data.download_url)) { image in
                                    image.resizable()
                                        .frame(width: 100, height: 100)
                                } placeholder: {
                                    Text("\(data.author)")
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Pictures")
        }
    }
}

#Preview {
    mFetchDataView()
}
