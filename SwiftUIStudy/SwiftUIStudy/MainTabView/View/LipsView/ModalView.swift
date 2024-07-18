//
//  ModalView.swift
//  SwiftUIStudy
//
//  Created by wonhoKim on 7/15/24.
//

import SwiftUI

struct SaveRecordingView: View {
    @Binding var fileName: String // 바인딩된 파일 이름 상태 변수
    var onSave: () -> Void // 저장 버튼 클릭 시 실행할 클로저
    
    var body: some View {
        VStack {
            Text("Enter file name")
                .font(.headline)
                .padding()
            
            TextField("File name", text: $fileName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: onSave) {
                Text("Save")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

