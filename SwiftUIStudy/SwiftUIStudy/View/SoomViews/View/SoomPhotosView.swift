//
//  SoomPhotosView.swift
//  SwiftUIStudy
//
//  Created by Soom on 7/24/24.
//

import SwiftUI

struct SoomPhotosView: View {
    @State var viewModel: SoomPhotosViewModel = SoomPhotosViewModel()
    @State private var currentData: String = ""
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            Text("남은 카드: \(viewModel.photos.count) \n드래그 해보세요~")
                .font(.largeTitle)
                .foregroundStyle(.black)
                .animation(.easeInOut)
                .frame(maxHeight: .infinity,alignment: .top)
                .padding(.top, 50)
            ForEach(viewModel.photos, id: \.id){ photo in
                CardView(photo: photo)
                    .rotationEffect(.degrees(Double(photo.id)! * 0.2))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                viewModel.updateCardState(photo: photo, translation: gesture.translation)
                            }
                            .onEnded { gesture in
                                viewModel.endDrag(photo: photo, translation: gesture.translation)
                            }
                    )
                    .animation(.spring)
                    .offset(x: photo.x, y: photo.y)
                    .rotationEffect(.degrees(Double(photo.x / 20)))
            }
            VStack{
                Spacer()
                Text("Gallery")
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 48)
                    )
            }
        }
    }
}



#Preview {
    SoomPhotosView()
}
