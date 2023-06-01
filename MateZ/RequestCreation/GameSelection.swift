//
//  GameSelection.swift
//  MateZ
//
//  Created by Giuseppe Rocco on 10/05/23.
//

import SwiftUI

struct GameSelection: View {
    @StateObject var appData: AppData
    @State var searchText: String = ""
    
    var body: some View {
        List(searchResults, id: \.self) { game in
            NavigationLink(destination: GameConfig(appData: appData, newRequest: UserRequest(
                uuid: "localrequest",
                user_id: appData.authData.username,
                game: game,
                time: 5,
                mic: false,
                region: appData.localProfile.region,
                pnumber: 1,
                skills: [],
                plat: appData.games[game]!.plat[0],
                mode: appData.games[game]!.modes[0],
                date: Date.now
            ))) {
                HStack {
                    RemoteImage(imgname: appData.games[game]!.imgname, squareSize: 35)
                        .frame(width: 35, height: 35)
                    Text(game)
                }
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("Select a game")
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return appData.games.map{$0.key}.sorted()
        } else {
            return appData.games.map{$0.key}.filter { $0.contains(searchText) }
        }
    }
}

struct GameSelection_Previews: PreviewProvider {
    static var previews: some View {
        GameSelection(appData: AppData())
    }
}
