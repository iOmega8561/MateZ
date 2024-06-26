/*
 Copyright (C) 2024  Giuseppe Rocco
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

//
//  UneditableProfile.swift
//  MateZ
//
//  Created by Giuseppe Rocco on 03/06/23.
//

import SwiftUI

struct UneditableProfile: View {
    @EnvironmentObject var appData: AppData
    let userProfile: UserProfile
    
    @State var error: Bool = false
    
    private let gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var theirRequests: [UserRequest] {
        let new = appData.requests.filter {
            $0.value.user_id == userProfile.username
        }.map{$0.value}
        
        return new.sorted(by: {$0.date > $1.date})
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color("BG").ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        HStack(alignment: .center) {
                            
                            
                            RemoteImage(imgname: userProfile.avatar, squareSize: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .frame(width: 100, height: 100)
                            
                            VStack(alignment: .leading) {
                                Text(userProfile.username)
                                    .font(.system(size: 25))
                                
                                HStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(Color("BDisabled"))
                                            .frame(width: 26,height: 20)
                                        
                                        Image(userProfile.region)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 21)
                                    }
                                    
                                    Text(userProfile.region.uppercased())
                                        .font(.system(size: 18))
                                }
                                
                            }
                            .padding([.horizontal, .bottom])
                            
                            Spacer()
                        }
                        .padding([.horizontal, .top])
                        
                        VStack(alignment: .leading) {
                            Text("Their requests")
                                .font(.title2)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(theirRequests, id: \.self) { req in
                                        NavigationLink(destination: LobbyDetails(request: req, userDetailEnabled: false).environmentObject(appData)) {
                                            LobbyBox(games: appData.games, request: req)
                                                .frame(width: proxy.size.width * 0.92, height: 120)
                                        }
                                        .foregroundColor(.primary)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Their games")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal)
                                
                                Spacer()
                            }
                            .padding(.trailing)
                            
                            LazyVGrid(columns: gridItemLayout, spacing: 10) {
                                ForEach(userProfile.fgames, id: \.self) { g in
                                    VStack {
                                        RemoteImage(imgname: appData.games[g]?.imgname ?? "game_default", squareSize: 70)
                                            .frame(width: 80, height: 80)
                                            .padding()
                                    }
                                    .background(Color("CardBG"))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("\(userProfile.username)'s Profile")
        }
    }
}

struct UneditableProfile_Previews: PreviewProvider {
    static var previews: some View {
        UneditableProfile(userProfile: UserProfile())
    }
}
