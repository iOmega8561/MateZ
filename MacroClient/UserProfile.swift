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
    
    @State var showDialog: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.949, green: 0.949, blue: 0.971)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer().frame(height: 10)
                    
                    RemoteImage(imgname: "user_generic", squareSize: 130)
                        .clipShape(Circle())
                    
                    Text(appData.authData.username)
                        .font(.title)
                    
                    Form {
                        Section(header: Text("Authentication")) {
                            Button(action: { showDialog.toggle() }) {
                                HStack {
                                    Spacer()
                                    Text("Log out")
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                            }
                            .confirmationDialog("Are you sure?", isPresented: $showDialog, titleVisibility: .visible) {
                                Button(role: .destructive) {
                                    Task {
                                        await appData.logout()
                                        showDialog = false; loggedIn = false
                                    }
                                } label: {
                                    Text("Yes, log me out.")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Your profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(appData: AppData(), loggedIn: .constant(true))
    }
}
