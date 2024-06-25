//
//  ContentView.swift
//  SwiftUIStudy
//
//  Created by Soom on 6/25/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView{
            SoomView()
                .tabItem {
                    Label("Soom", systemImage: "person.circle.fill")
                }
            So0View()
                .tabItem {
                    Label("So0", systemImage: "person.circle.fill")
                }
            LipsView()
                .tabItem {
                    Label("Lips", systemImage: "person.crop.circle.fill")
                }
            SumchiveView()
                .tabItem {
                    Label("Sumchive", systemImage: "person.circle.fill")
                }
            ActIveView()
                .tabItem {
                    Label("ActIve", systemImage: "person.crop.circle.fill")
                }
            MarbleView()
                .tabItem {
                    Label("Marble", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
