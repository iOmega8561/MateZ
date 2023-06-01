//
//  FavouritePicker.swift
//  MateZ
//
//  Created by Giuseppe Rocco on 25/05/23.
//

import SwiftUI

struct FavouritePicker: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    @StateObject var appData: AppData
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            List(searchResults, id: \.self) { game in
                NavigationLink(destination: PlatformPicker(appData: appData, game: FavouriteGame(
                    name: game, plat: []
                )).navigationTitle("Platform")) {
                    HStack {
                        RemoteImage(imgname: appData.games[game]!.imgname, squareSize: 35)
                            .frame(width: 35, height: 35)
                        Text(game)
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Select a game")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {dismiss()}) {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .onChange(of: scenePhase) { _ in
            if searchResults.count < 1 {
                dismiss()
            }
        }
    }
    
    var fgamesList: [String] {
        return appData.localProfile.fgames.map{$0.name}
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return appData.games.map{$0.key}.filter{
                !fgamesList.contains($0)
            }.sorted()
        } else {
            return appData.games.map{$0.key}.filter {
                $0.contains(searchText) && !fgamesList.contains($0)
            }.sorted()        }
    }
}

struct FavouritePicker_Previews: PreviewProvider {
    static var previews: some View {
        FavouritePicker(appData: AppData())
    }
}
