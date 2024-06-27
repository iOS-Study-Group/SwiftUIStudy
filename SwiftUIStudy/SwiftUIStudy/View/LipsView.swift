//
//  LipsView.swift
//  SwiftUIStudy
//
//  Created by Soom on 6/25/24.
//

import SwiftUI

struct LipsView: View {
    @State var insert: String = ""
    //입력한 텍스트 배열로 저장
    @State var newInsertTexts: [String] = []
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    HStack {
                        TextField("텍스트를 입력하세요", text: $insert)
                        Button(action: {
                            //텍스트필드에 입력된 테스트가 비어지지 않았을때
                            if !insert.isEmpty{
                                newInsertTexts.append(insert)
                                insert = "" //텍스트 초기화해서 새로운 텍스트 입력할수 있게
                                
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    Section("") {
                        ForEach(newInsertTexts, id: \.self){ newInsertText in //newInsertText 배열에 저장된 각요소
                            Text(newInsertText)
                        }
                        
                    }
                }
                .navigationTitle("탭뷰 꾸미기")
            }
        }
    }
}

#Preview {
    LipsView()
}
