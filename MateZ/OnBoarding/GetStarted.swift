//
//  GetStarted.swift
//  MateZ
//
//  Created by Giuseppe Rocco on 05/06/23.
//

import SwiftUI

struct GetStarted: View {
    @StateObject var appData: AppData
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BG").ignoresSafeArea()
                
                VStack {
                    
                    Text("Welcome to MateZ")
                        .font(.title)
                    
                    Spacer()
                    
                    NavigationLink(destination: AvatarSelection(appData: appData)) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.accentColor)
                            .frame(width: 150, height: 50)
                            .overlay {
                                Text("Get started")
                                    .foregroundColor(.primary)
                            }
                    }
                    
                }.padding()
            }.navigationTitle("Hello \(appData.localProfile.username)")
        }.navigationViewStyle(.stack)
    }
}

struct GetStarted_Previews: PreviewProvider {
    static var previews: some View {
        GetStarted(appData: AppData())
    }
}
