//
//  SoomCameraView.swift
//  SwiftUIStudy
//
//  Created by Soom on 8/17/24.
//
import SwiftUI

struct SoomCameraView: View {
    @StateObject private var model: DataModel = DataModel()
    private static let barHeightFactor = 0.15
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ViewfinderView(image: $model.viewfinderImage)
                    .overlay(alignment: .top) {
                        Color.black
                            .opacity(0.75)
                            .frame(height: geometry.size.height * Self.barHeightFactor - 10)
                    }
                    .overlay(alignment: .bottom) {
                        buttonsView()
                            .frame(height: geometry.size.height * Self.barHeightFactor)
                            .background(.black.opacity(0.75))
                    }
                    .overlay(alignment: .center)  {
                        Color.clear
                            .frame(height: geometry.size.height * (1 - (Self.barHeightFactor * 2)))
                            .accessibilityElement()
                            .accessibilityLabel("View Finder")
                            .accessibilityAddTraits([.isImage])
                    }
                    .background(.black)
            }
            .task{
                await model.camera.start()
            }
        }
    }
    @ViewBuilder
    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            Spacer()
            
            NavigationLink{
                
            }label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(width: 35, height: 35)
                }
            }
            Button {
                model.camera.takePhoto()
            } label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 3)
                            .frame(width: 62, height: 62)
                        Circle()
                            .fill(.white)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            
            Button {
                model.camera.switchCaptureDevice()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
       }
}


struct ViewfinderView: View {
    @Binding var image: Image?
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}


#Preview {
    SoomCameraView()
}
