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
        if linkDataManager.linkData.isSuccess {
            ZStack {
                ScrollView() {
                    LazyVGrid(columns: [.init(), .init()]) {
                        ForEach(linkDataManager.linkData.jsonDatas) { jsonData in
                            AsyncImage(url: URL(string: jsonData.download_url)) { image in
                                ZStack {
                                    // 이미지 평균 색상으로 배경색 설정
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color(ImageRenderer(content: image).uiImage?.avgColor ?? .systemGray5))
                                    VStack(alignment: .leading) {
                                        Text(jsonData.author)
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                    .padding()
                                }
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                }
                .padding()
            }
        } else {
            Text(linkDataManager.linkData.result)
        }
    }
}

// 이미지 평균 색상 값을 추출
extension UIImage {
    var avgColor: UIColor? {
        guard let inputImage = CIImage(image: self) else {
            return nil
        }
        
        let exVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: exVector]) else {
            return nil
        }
        
        guard let output = filter.outputImage else {
            return nil
        }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        
        context.render(output, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: 0.5)
    }
}

#Preview {
    SLinkDataView()
}
