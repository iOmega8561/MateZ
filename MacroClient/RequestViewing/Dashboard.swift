//
//  Dashboard.swift
//  MateZ
//
//  Created by Giuseppe Rocco on 29/04/23.
//

import SwiftUI

struct Dashboard: View {
    @State var refreshDone: Bool = false
    @State var logoutActive: Bool = false
    @StateObject var appData: AppData
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                
                if !refreshDone {
                    CustomProgress(withText: true)
                } else {
                    
                    ScrollView {
                        LazyVStack {
                            if appData.requests.count < 1 {
                                Text("")
                            }
                            
                            ForEach(appData.requests.map{$0.value}, id: \.self) { req in
                                NavigationLink(destination: RequestDetails(appData: appData, request: req)) {
                                    RequestBox(games: appData.games, request: req)
                                        .frame(width: proxy.size.width * 0.92, height: proxy.size.height * 0.24)
                                        .contextMenu{
                                            Button(role: .destructive, action:{
                                                let uuid = req.uuid
                                                
                                                Task {
                                                    await appData.deleteUserRequest(uuid: uuid)
                                                }
                                            }){
                                                Text("Delete request")
                                            }.disabled(req.user_id != appData.authData.username)
                                        }
                                }.foregroundColor(.black)
                            }
                        }
                    }
                    .refreshable {
                        refreshDone = await appData.fetchUserRequests()
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
