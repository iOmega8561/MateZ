//
//  PlatformPicker.swift
//  MateZ
//
//  Created by Giuseppe Rocco on 25/05/23.
//

import SwiftUI

struct PlatformPicker: View {
    @StateObject var appData: AppData
    @State var game: FavouriteGame
    
    @State var error: Bool = false
    
    var body: some View {
        List {
            ForEach(appData.games[game.name]!.plat, id: \.self) { plat in
                Button {
                    if let index = game.plat.firstIndex(of: plat) {
                        game.plat.remove(at: index)
                    } else { game.plat.append(plat) }
                } label: {
                    HStack {
                        Image(plat)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                        
                        Text(plat).foregroundColor(.primary)
                        
                        if game.plat.firstIndex(of: plat) != nil {
                            Spacer()
                            Image(systemName: "checkmark")
                                .renderingMode(.template)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if game.plat.count < 1 {
                        error.toggle()
                    } else {
                        Task {
                            appData.localProfile.fgames.append(game)
                            await appData.updateUser()
                        }
                    }
                } label: {
                    Text("Save and Exit")
                }
                .alert("Select at least one platform", isPresented: $error) {
                    Button("OK", role: .cancel) { }
                }
            }
        }
    }
}

struct PlatformPicker_Previews: PreviewProvider {
    static var previews: some View {
        PlatformPicker(appData: AppData(), game: FavouriteGame(
            name: "League of Legends",
            plat: []
        ))
    }
}
