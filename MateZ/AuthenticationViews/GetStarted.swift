//
//  GetStarted.swift
//  MateZ
//
//  Created by Giuseppe Rocco on 06/06/23.
//

import SwiftUI

struct GetStarted: View {
    @StateObject var appData: AppData
    @Binding var loggedIn: Bool
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color("BG").ignoresSafeArea()
                
                VStack(alignment: .center, spacing: -140) {
                    
                    Image("GetStarted")
                        .resizable()
                        .scaledToFit()
                    
                    LinearGradient(colors: [Color.clear, Color("GS1"), Color("GS2"), Color("GS3"), Color("GS4")], startPoint: .top, endPoint: .bottom)
                        .frame(height: 300)
                    
                    Spacer()
                }
                .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    
                    Spacer()
                    
                    Text("MateZ")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.bottom, 5)
                    
                    Text("Power up your play with perfect partners!")
                        .padding(.bottom, 30)
                    
                    NavigationLink(destination: Signup(appData: appData, loggedIn: $loggedIn)) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.accentColor)
                            .frame(width: 220, height: 50)
                            .overlay {
                                Text("Get started")
                                    .foregroundColor(.primary)
                                    .font(.system(size: 17, weight: .bold))
                            }
                    }
                    
                    HStack {
                        Text("Already have an account?")
                            .font(.caption)
                        
                        NavigationLink(destination: Login(appData: AppData(), loggedIn: $loggedIn)) {
                            Text("Log In")
                                .font(.system(size: 12, weight: .semibold))
                        }
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                }.padding()
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct GetStarted_Previews: PreviewProvider {
    static var previews: some View {
        GetStarted(appData: AppData(), loggedIn: .constant(false))
    }
}
