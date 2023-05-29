//
//  Dashboard.swift
//  MacroClient
//
//  Created by Giuseppe Rocco on 29/04/23.
//

import SwiftUI

struct Dashboard: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var refreshDone: Bool = false
    @State var logoutActive: Bool = false
    @StateObject var appData: AppData
    
    var notMyRequests: [String: UserRequest] {
        return appData.requests.filter {
            $0.value.user_id != appData.authData.username
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                GeometryReader { proxy in
                    
                    if !refreshDone {
                        CustomProgress(withText: true)
                    } else {
                        
                        ScrollView {
                            LazyVStack {
                                if appData.requests.count < 1 {
                                    Text("")
                                }
                                
                                ForEach(notMyRequests.map{$0.value}, id: \.self) { req in
                                    NavigationLink(destination: RequestDetails(appData: appData, request: req)) {
                                        RequestBox(games: appData.games, request: req)
                                            .frame(width: proxy.size.width * 0.92, height: proxy.size.height * 0.24)
                                    }.foregroundColor(.primary)
                                }
                            }
                        }
                        .refreshable {
                            _ = await appData.fetchUserRequests()
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                        .navigationTitle("Requests")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink(destination: GameSelection(appData: appData)) {
                                    HStack {
                                        Text("New")
                                        Image(systemName: "plus")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .task {
            await appData.fetchRemoteGames()
            
            refreshDone = await appData.fetchUserRequests()
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard(appData: AppData())
    }
}
