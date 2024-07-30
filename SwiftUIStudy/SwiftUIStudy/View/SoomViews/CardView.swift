//
//  CardView.swift
//  SwiftUIStudy
//
//  Created by Soom on 7/28/24.
//

import SwiftUI

struct CardView:View {
    let photo: SoomPhotoModel
    @State private var tempColors: [Color] = [
        .red, .blue, .green, .orange, .purple,
        .pink, .yellow, .gray, .black, .white,
        .brown, .cyan, .mint, .indigo, .teal,
        .red.opacity(0.7), .blue.opacity(0.7), .green.opacity(0.7), .orange.opacity(0.7), .purple.opacity(0.7),
        .pink.opacity(0.7), .yellow.opacity(0.7), .gray.opacity(0.7), .black.opacity(0.7), .white.opacity(0.7),
        .brown.opacity(0.7), .cyan.opacity(0.7), .mint.opacity(0.7), .indigo.opacity(0.7), .teal.opacity(0.7)
    ]
    @State var tempColor: Color = .black
    var body: some View {
        ZStack{
            AsyncImage(url:  URL(string: photo.downloadURL)){ phase in
                switch phase {
                case .empty:
                    Text("잠시만 기다려주세요")
                        .frame(maxWidth: .infinity)
                        .frame(height: 386)
                        .foregroundStyle(.white)
                        .background(RoundedRectangle(cornerRadius: 24).fill(tempColor.gradient.opacity(0.4)))
                        .animation(.spring)
                        .onAppear{
                            if let tempColor = tempColors.randomElement(){
                                self.tempColor = tempColor
                            }
                        }
                case .success(let image):
                    image
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .frame(height: 386)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .animation(.spring)
                        .overlay{
                            VStack{
                                Spacer()
                                HStack(alignment: .bottom, spacing: 12){
                                    Text(photo.author)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text("00:00:00")
                                        .font(.title3)
                                        .foregroundStyle(.white)
                                        .padding(.bottom,3)
                                    Spacer()
                                    Image(systemName: "beach.umbrella.fill")
                                        .frame(width: 32,height: 32)
                                        .foregroundStyle(.white)
                                        .padding(3)
                                        .background(
                                            Circle()
                                                .fill(.mint.gradient)
                                        )
                                }
                                .padding(.horizontal,30)
                                .padding(.bottom,30)
                            }
                        }
                case .failure(let error):
                    Text("이미지 불러오기 실패")
                @unknown default:
                    fatalError()
                }
            }
        }
        .padding(.horizontal,50)
    }
}

#Preview {
    CardView(photo: SoomPhotoModel.dummyData)
}
