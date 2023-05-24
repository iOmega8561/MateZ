//
//  Dashboard.swift
//  MateZ
//
//  Created by Giuseppe Rocco on 29/04/23.
//

import SwiftUI

struct Dashboard: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
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
                                
                                if req.user_id == appData.authData.username {
                                    NavigationLink(destination: RequestDetails(appData: appData, request: req).toolbar {
                                        ToolbarItem(placement: .navigationBarTrailing) {
                                            Button {
                                                let uuid = req.uuid
                                                
                                                Task {
                                                    await appData.deleteUserRequest(uuid: uuid)
                                                    presentationMode.wrappedValue.dismiss()
                                                }
                                            } label: {
                                                Text("Delete")
                                                    .foregroundColor(.red)
                                            }
                                        }
                                    }) {
                                        RequestBox(games: appData.games, request: req)
                                            .frame(width: proxy.size.width * 0.92, height: proxy.size.height * 0.24)
                                    }.foregroundColor(.primary)
                                } else {
                                    NavigationLink(destination: RequestDetails(appData: appData, request: req)) {
                                        RequestBox(games: appData.games, request: req)
                                            .frame(width: proxy.size.width * 0.92, height: proxy.size.height * 0.24)
                                    }.foregroundColor(.primary)
                                }
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
