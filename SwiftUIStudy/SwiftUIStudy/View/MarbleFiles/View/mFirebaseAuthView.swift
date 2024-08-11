//
//  mFirebaseAuthView.swift
//  SwiftUIStudy
//
//  Created by 강승우 on 2024/07/30.
//

import SwiftUI

struct mFirebaseAuthView: View {
    @ObservedObject var authManager : mAuthenticationManager = mAuthenticationManager()

    @State var isSignUp: Bool = false
    @State var isSignIn: Bool = false
    
    var body: some View {
        if isSignIn {
            mFetchDataView()
        } else {
            ZStack {
                VStack {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.92)
                        .foregroundColor(backColor)
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.15)
                        .foregroundColor(.white)
                }
                VStack {
                    HStack{
                        Image("marioTitle")
                            .resizable()
                            .frame(width: 250)
                            .scaledToFit()
                        Image("marioImage")
                            .resizable()
                            .frame(width: 70)
                            .scaledToFit()
                    }
                    .frame(height: 100)
                    .padding(.bottom, 30)
                    HStack {
                        Text("Sign In")
                            .foregroundStyle(.white)
                            .opacity(!isSignUp ? 1.0 : 0.5)
                            .padding(.bottom, 9)
                            .onTapGesture{
                                isSignUp = false
                            }
                        Text("Sign Up")
                            .foregroundStyle(.white)
                            .opacity(isSignUp ? 1.0 : 0.5)
                            .padding(.bottom, 9)
                            .onTapGesture {
                                isSignUp = true
                            }
                        Spacer()
                    }
                    .frame(width : UIScreen.main.bounds.width * 0.75)
                    .border(width : 1, edges : [.bottom], color: .white)
                    
                    if isSignUp {
                        mFirebaseSignupView(isSignUp : $isSignUp)
                            .environmentObject(authManager)
                    } else {
                        mFirebaseSignInView(isSignIn : $isSignIn)
                            .environmentObject(authManager)
                    }
                }
                .padding(.bottom, UIScreen.main.bounds.height * 0.3)
            }
        }
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

#Preview {
    mFirebaseAuthView()
}
