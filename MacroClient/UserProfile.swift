//
//  Profile.swift
//  MateZ
//
//  Created by Giuseppe Rocco on 19/05/23.
//

import SwiftUI

struct Profile: View {
    @StateObject var appData: AppData
    @Binding var loggedIn: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.949, green: 0.949, blue: 0.971)
                    .ignoresSafeArea()
                
                VStack {
                    RemoteImage(imgname: "user_generic", squareSize: 130)
                        .clipShape(Circle())
                    
                    Text(appData.authData.username)
                        .font(.title)
                    
                    Form {
                        Section(header: Text("Authentication")) {
                            Button {
                                Task {
                                    await appData.logout()
                                    loggedIn = false
                                }
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Log out")
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("User profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(appData: AppData(), loggedIn: .constant(true))
    }
}
