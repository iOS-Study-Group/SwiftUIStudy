//
//  ScData_View_Main.swift
//  SwiftUIStudy
//
//  Created by 김수민 on 7/24/24.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = ScData_ViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            Group {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.picsumPhotos) { photo in
                            NavigationLink(destination: PhotoInfoView(picsumPhoto: photo)) {
                                VStack {
                                    AsyncImage(url: URL(string: photo.download_url)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 160, height: 160)
                                            .clipped()
                                            .shadow(color: .white, radius: 5)
                                    } placeholder: {
                                        Color.clear
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .background(Color.black.edgesIgnoringSafeArea(.all))
            } .navigationBarTitleDisplayMode(.inline) 
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack{
                            Text("Gallery")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Image(systemName: "photo")
                        }
                        .foregroundColor(.white)
                    }
                }
        }
        .task {
            do {
                try await viewModel.getJsonFile()
            } catch {
                print("!ERROR! : \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    MainView()
}
