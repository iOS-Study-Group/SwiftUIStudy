//
//  MarbleView.swift
//  SwiftUIStudy
//
//  Created by Soom on 6/25/24.
//

import SwiftUI

struct MarbleView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("실습 목록")
                    .font(.system(size: 24, weight: .bold))
                
                List {
                    NavigationLink {
                        mCalcView()
                    } label: {
                        listLabel("24.06.18", "계산기")
                    }
                    NavigationLink {
                        mLottoView()
                    } label: {
                        listLabel("24.07.02", "로또 번호 생성기")
                    }
                    NavigationLink {
                        mVoiceView()
                    } label: {
                        listLabel("24.07.09", "음성 앱")
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

extension MarbleView {
    func listLabel(_ date : String, _ title : String) -> some View {
        VStack(alignment:.leading) {
            Text(date)
                .font(.system(size: 16))
            Text(title)
                .font(.system(size: 12))
        }
    }
}

#Preview {
    MarbleView()
}
