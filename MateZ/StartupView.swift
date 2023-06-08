//
//  CredentialCheck.swift
//  MateZ
//
//  Created by Giuseppe Rocco on 18/05/23.
//

import SwiftUI

struct StartupView: View {
    @EnvironmentObject var appData: AppData
    
    @State var isLoading: Bool = true
    @State var loggedIn: Bool = false
    
    var body: some View {
        Group {
            
            if isLoading {
                ZStack {
                    Color("BG").ignoresSafeArea()
                    CustomProgress(withText: true)
                }
                
            } else if !loggedIn {
                GetStarted(loggedIn: $loggedIn)
                    .environmentObject(appData)
                
            } else if loggedIn && !appData.getStartedDone {
                NavigationView {
                    InitialConfig()
                        .environmentObject(appData)
                }
                .navigationViewStyle(.stack)
                
            } else if loggedIn && appData.getStartedDone {
                TabView {
                    
                    Dashboard()
                        .environmentObject(appData)
                        .tabItem {
                            Label("Lobbies", systemImage: "person.3")
                        }
                    
                    DummyView()
                        .environmentObject(appData)
                        .tabItem {
                            Label("Requests", systemImage: "personalhotspot")
                        }
                    
                    ChatScreen()
                        .environmentObject(appData)
                        .tabItem{
                            Label("Messages", systemImage: "bubble.left")
                        }
                    
                    Profile(loggedIn: $loggedIn)
                        .environmentObject(appData)
                        .onAppear {
                            Task {
                                await appData.refreshProfile()
                            }
                        }
                        .tabItem{
                            Label("Profile", systemImage: "person")
                        }
                   
                }
            }
        }
        .task {
            do {
                try await appData.load()
                
                if appData.authData.username != "na" && appData.authData.token != "na" {
                    let response = await appData.lastsession()
                    
                    if response == "Success" {
                        await appData.refreshProfile()
                        
                        loggedIn = true
                    }
                }
                
                isLoading = false
            } catch {
                print("Error loading data")
            }
        }
    }
}

struct StartupView_Previews: PreviewProvider {
    static var previews: some View {
        StartupView()
    }
}
