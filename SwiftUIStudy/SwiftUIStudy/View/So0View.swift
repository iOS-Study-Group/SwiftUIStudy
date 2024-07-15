//
//  So0View.swift
//  SwiftUIStudy
//
//  Created by Soom on 6/25/24.
//

import SwiftUI
import AVFoundation

struct Members: Identifiable {
    var id: UUID = UUID()
    var nick: String
    var name: String
    var message: String
}

struct So0View: View {
    let members: [Members] = [
        Members(nick: "Soom", name: "수은님", message: " 몬가 믿음직스러워여"),
        Members(nick: "So0", name: "소영", message: "은 내 이름\n"),
        Members(nick: "Lips", name: "원호님", message: " 리더 감사합니당"),
        Members(nick: "Sumchive", name: "수민님", message: " 또 같은조 돼서 조아요"),
        Members(nick: "ActIve", name: "문성님", message: " 열심히 해보자구욤"),
        Members(nick: "Marble", name: "승우님", message: " 저희 동갑이네용")
    ]
    let speechSynth = AVSpeechSynthesizer()
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.indigo, .white]), startPoint: .bottom, endPoint: .top)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Label("So0's tab", systemImage: "swift")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    Section("Swift Study Group") {
                        LazyVGrid(columns: [.init(), .init()]) {
                            ForEach(members) { member in
                                GroupBox("🔆\(member.nick)") {
                                    let comMessage: String = "\(member.name + member.message)"
                                    Button(comMessage) {
                                        let utterance = AVSpeechUtterance(string: comMessage)
                                        speechSynth.speak(utterance)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    Section("Task") {
                        ScrollView() {
                            VStack(alignment:.leading) {
                                NavigationLink {
                                    
                                } label: {
                                    VStack {
                                        Text("1주차")
                                            .frame(maxWidth: .infinity)
                                        Text("화면 꾸미기")
                                            .font(.system(size: 12))
                                    }
                                        
                                }
                                .disabled(true)
                                .buttonStyle(.borderedProminent)
                                .tint(.white)
                                
                                NavigationLink {
                                    SLottoView()
                                } label: {
                                    VStack {
                                        Text("2주차")
                                            .frame(maxWidth: .infinity)
                                        Text("로또 만들기")
                                            .font(.system(size: 12))
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.white)
                                
                                NavigationLink {
                                    SRecordView()
                                } label: {
                                    VStack {
                                        Text("3주차")
                                            .frame(maxWidth: .infinity)
                                        Text("녹음기 만들기")
                                            .font(.system(size: 12))
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.white)
                            }
                        }
                        .bold()
                        .foregroundStyle(.black)
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    So0View()
}
