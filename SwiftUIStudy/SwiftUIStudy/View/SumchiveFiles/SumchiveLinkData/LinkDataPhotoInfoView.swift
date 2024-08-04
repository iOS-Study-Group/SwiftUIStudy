//
//  ScData_View.swift
//  SwiftUIStudy
//
//  Created by 김수민 on 7/24/24.
//

import SwiftUI

struct PhotoInfoView: View {
    
    let picsumPhoto: PicsumPhoto
    @State private var buttonClicked: Bool = false
    
    var body: some View {
        ZStack{
            Color(.black).ignoresSafeArea()
            
            VStack(alignment: .center,spacing: 20) {
                
                AsyncImage(url: URL(string: picsumPhoto.download_url)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .shadow(color: .white, radius: 5)
                        .padding(.horizontal, 20)
                } placeholder: {
                    ProgressView()
                }
                
                Button {
                    buttonClicked = true
                } label: {
                    HStack{
                        Text("Photo Info")
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                        Image(systemName: "info.bubble")
                            .font(.system(size: 30))
                    }.foregroundColor(.white)
                }
                
                if buttonClicked {
                    VStack(spacing: 20) {
                        Divider()
                            .background(Color.white)
                        Text("AUTHOR")
                            .fontWeight(.bold)
                        Text("\(picsumPhoto.author)")
                        Divider()
                            .background(Color.white)
                        Text("SIZE")
                            .fontWeight(.bold)
                        Text("\(picsumPhoto.width) X \(picsumPhoto.height)")
                        Divider()
                            .background(Color.white)
                        Text("WEBSITE")
                            .fontWeight(.bold)
                        WebView(picsumPhoto: picsumPhoto, webUrl: picsumPhoto.url)
                            .frame(height: 250)
                            .padding(.horizontal, 20)
                        
                    }
                    .font(.system(size: 15, design: .monospaced))
                    .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    PhotoInfoView(picsumPhoto: PicsumPhoto.init(id:"0",author: "Alejandro Escamilla",width: 5000,height: 3333,url: "https://unsplash.com/photos/yC-Yzbqy7PY",download_url: "https://picsum.photos/id/0/5000/3333"))
}
