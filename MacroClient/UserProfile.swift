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
        VStack {
            Button {
                Task {
                    await appData.logout()
                    loggedIn = false
                }
            } label: {
                Text("Log out")
                    .foregroundColor(.red)
            }
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(appData: AppData(), loggedIn: .constant(true))
    }
}
