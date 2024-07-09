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
                        VStack(alignment:.leading) {
                            Text("24.06.18")
                                .font(.system(size: 16))
                            Text("계산기")
                                .font(.system(size: 12))
                        }
                    }
                    NavigationLink {
                        mLottoView()
                    } label: {
                        VStack(alignment:.leading) {
                            Text("24.07.02")
                                .font(.system(size: 16))
                            Text("로또 번호 생성기")
                                .font(.system(size: 12))
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    MarbleView()
}
