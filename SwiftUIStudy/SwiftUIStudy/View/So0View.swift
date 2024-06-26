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
        Members(nick: "So0", name: "소영", message: "은 내 이름"),
        Members(nick: "Lips", name: "원호님", message: " 리더 감사합니당"),
        Members(nick: "Sumchive", name: "수민님", message: " 또 같은조 돼서 조아요"),
        Members(nick: "ActIve", name: "문성님", message: " 열심히 해보자구욤"),
        Members(nick: "Marble", name: "승우님", message: " 저희 동갑이네용")
    ]
    let speechSynth = AVSpeechSynthesizer()
    
    var body: some View {
        VStack {
            Text("So0's tab")
                .font(.title)
                .bold()
            List (members) { member in
                GroupBox("\(member.nick)") {
                    let comMessage: String = "\(member.name + member.message)"
                    Button(comMessage) {
                        let utterance = AVSpeechUtterance(string: comMessage)
                        speechSynth.speak(utterance)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("My Favorite Apps")
    }
}

#Preview {
    So0View()
}
