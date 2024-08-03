//
//  LipsDataView.swift
//  SwiftUIStudy
//
//  Created by wonhoKim on 7/27/24.
//
//public enum AsyncImagePhase : Sendable {
//
//    /// No image is loaded.
//    case empty
//
//    /// An image succesfully loaded.
//    case success(Image)
//
//    /// An image failed to load with an error.
//    case failure(any Error)
//
//    /// The loaded image, if any.
//    ///
//    /// If this value isn't `nil`, the image load operation has finished,
//    /// and you can use the image to update the view. You can use the image
//    /// directly, or you can modify it in some way. For example, you can add
//    /// a ``Image/resizable(capInsets:resizingMode:)`` modifier to make the
//    /// image resizable.
//    public var image: Image? { get }
//
//    /// The error that occurred when attempting to load an image, if any.
//    public var error: (any Error)? { get }
//}

import SwiftUI

struct LipsDataView: View {
    @StateObject var viewModel = LipsViewModel()
    
    var body: some View {
        VStack {
            List(viewModel.images) { image in
                HStack {
                    AsyncImage(url: URL(string: image.download_url)) { asyncImage in
                        switch asyncImage {
                        case .empty:
                            ProgressView()
                                .frame(width: 100, height: 100)
                        case .success(let loadImage):
                            loadImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                        case .failure:
                            Text("이미지 로드에 실패")
                        @unknown default:
                            fatalError()
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("author: \(image.author)")
                            .font(.headline)
                        Text("size: \(image.width) x \(image.height)")
                            .font(.subheadline)
                        Text("url: \(image.url)")
                    }
                }
            }
        }
        .background(Color.gray)
        Button(action: {
            viewModel.loadImage()
        }, label: {
            Text("데이터 받아오기!")
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                .foregroundColor(.white)
        })
    }
}

#Preview {
    LipsDataView()
}
