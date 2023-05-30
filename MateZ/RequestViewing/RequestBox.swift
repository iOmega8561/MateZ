//
//  RequestBox.swift
//  MateZ
//
//  Created by Giuseppe Rocco on 29/04/23.
//

import SwiftUI

struct RequestBox: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let games: [String: Game]
    let request: UserRequest
    
    let dark: RadialGradient = RadialGradient(colors: [Color(UIColor.systemGray4), Color(UIColor.systemGray6)], center: .center, startRadius: 20, endRadius: 200)
    
    let light: RadialGradient = RadialGradient(colors: [.white, .gray], center: .center, startRadius: 20, endRadius: 500)
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10.0)
            .fill(Color(UIColor.secondarySystemGroupedBackground))
        //.fill(colorScheme == .light ? light:dark)
        //.shadow(color: colorScheme == .light ? .secondary:.black, radius: 3)
            .overlay(
                HStack {
                    
                    Spacer().frame(width: 15)
                    
                    VStack {
                        Spacer().frame(height: 15)
                        
                        HStack {
                            RemoteImage(imgname: games[request.game]?.imgname ?? "game_generic")
                                .frame(width: 60.0, height: 60.0)
                                .shadow(radius: 4.0)
                            
                            Spacer().frame(width: 10)
                            
                            VStack {
                                HStack {
                                    Text(request.game)
                                    
                                        .font(.system(size: 25, weight: .semibold))
                                        .lineLimit(1)
                                    Spacer()
                                }.padding(.leading)
                                
                                HStack {
                                    Spacer().frame(width: 10)
                                    Text("👤 \(request.pnumber)   \(request.skills.count > 0 ? request.skills.joined(separator: ", "):"Any role")")
                                        .font(.system(size: 20, weight: .semibold))
                                        .lineLimit(1)
                                    
                                    Spacer()
                                }
                            }
                        }
                        
                        Spacer()
                        
                        HStack {
                            Spacer().frame(width: 5)
                            
                            Image(request.plat)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35.0, height: 35.0)
                            
                            Spacer().frame(width: 10)
                            
                            Text("🎮 \(request.mode)")
                                .font(.system(size: 20, weight: .semibold))
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text("🌎 \(request.region)")
                                .font(.system(size: 20, weight: .semibold))
                                .lineLimit(1)
                            
                            Spacer().frame(width: 5)
                        }
                        
                        Spacer().frame(height: 15)
                    }
                    
                    Spacer().frame(width: 15)
                }
            )
    }
}

struct RequestBox_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard(appData: AppData())
    }
}
