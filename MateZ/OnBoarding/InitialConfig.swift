//
//  GetStarted.swift
//  MateZ
//
//  Created by Giuseppe Rocco on 05/06/23.
//

import SwiftUI

struct InitialConfig: View {
    @StateObject var appData: AppData
    
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
                    
                    Text("Welcome, Mate!")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.bottom, 5)
                    
                    Text("Set up your profile to find team mateZ!")
                        .padding(.bottom, 30)
                    
                    NavigationLink(destination: AvatarSelection(appData: appData)) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.accentColor)
                            .frame(width: 220, height: 50)
                            .overlay {
                                Text("Get started")
                                    .foregroundColor(.primary)
                                    .font(.system(size: 17, weight: .bold))
                            }
                    }
                    
                    Spacer()
                        .frame(height: 34)
                    
                }.padding()
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct InitialConfig_Previews: PreviewProvider {
    static var previews: some View {
        InitialConfig(appData: AppData())
    }
}
