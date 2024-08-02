//
//  ScData_View_Web.swift
//  SwiftUIStudy
//
//  Created by 김수민 on 7/24/24.
//

import SwiftUI
import WebKit
 
struct WebView: UIViewRepresentable {
    let picsumPhoto: PicsumPhoto
    
    var webUrl: String
    
    func makeUIView(context: Context) -> WKWebView {
        
        guard let url = URL(string: self.webUrl) else {
            return WKWebView()
        }

        let webView = WKWebView()

        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        
    }
}

#Preview {
    WebView(
        picsumPhoto: PicsumPhoto(
            id: "0",
            author: "Alejandro Escamilla",
            width: 5000,
            height: 3333,
            url: "https://unsplash.com/photos/yC-Yzbqy7PY",
            download_url: "https://picsum.photos/id/0/5000/3333"
        ),
        webUrl: "https://unsplash.com/photos/yC-Yzbqy7PY"
    )
}
