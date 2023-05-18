//
//  CredentialCheck.swift
//  MateZ
//
//  Created by Giuseppe Rocco on 18/05/23.
//

import SwiftUI

struct LastSession: View {
    @StateObject var appData: AppData
    @State var isLoading: Bool = true
    @State var status: Int = 0
    
    var body: some View {
        Group {
            
            if isLoading {
                CustomProgress(withText: true)
            } else if status == 0 {
                Login(appData: appData)
            } else {
                MainView(appData: appData)
            }
            
        }.task {
            do {
                try await appData.load()
                
                if appData.authData.token != "na" && appData.authData.token != "na" {
                    let response = await appData.lastsession()
                    
                    if response == "Success" {
                        status = 1
                    }
                }
                
                isLoading = false
            } catch {
                print("Error loading data")
            }
        }
    }
}

struct LastSession_Previews: PreviewProvider {
    static var previews: some View {
        LastSession(appData: AppData())
    }
}
