//
//  NewRequest.swift
//  MacroClient
//
//  Created by Giuseppe Rocco on 10/05/23.
//

import SwiftUI

struct GameConfig: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject var appData: AppData
    @State var newRequest: UserRequest
    @State var showModal: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Select platform and game mode")) {
                Picker("Platform", selection: $newRequest.plat) {
                    ForEach(appData.games[newRequest.game]!.plat, id: \.self) { plat in
                        Text(plat)
                    }
                }.pickerStyle(.segmented)
                
                Picker("Gamemodes", selection: $newRequest.mode) {
                    ForEach(appData.games[newRequest.game]!.modes, id: \.self) { mode in
                        Text(mode)
                    }
                }.pickerStyle(.wheel)
            }
            if appData.games[newRequest.game]!.skills.count > 0 {
                Section(header: Text("Select roles to search for")) {
                    ForEach(appData.games[newRequest.game]!.skills, id: \.self) { skill in
                        
                        Button {
                            if let index = newRequest.skills.firstIndex(of: skill) {
                                newRequest.skills.remove(at: index)
                            } else { newRequest.skills.append(skill) }
                        } label: {
                            HStack {
                                Text(skill).foregroundColor(.primary)
                                
                                if newRequest.skills.firstIndex(of: skill) != nil {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .renderingMode(.template)
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                }
            }
            
            Section(header: Text("Other details")) {
                Toggle("Microphone required", isOn: $newRequest.mic)
                
                Stepper("Players needed: \(newRequest.pnumber)", value: $newRequest.pnumber, in: 1...20, step: 1)
                
                Stepper("Expiration time: \(newRequest.time) min", value: $newRequest.time, in: 5...120, step: 5)
                
                Button(action: {showModal.toggle()}) {
                    HStack {
                        Text("Region")
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(regions.first(where: {$1 == newRequest.region})?.key ?? "N/A")
                            .foregroundColor(.accentColor)
                            
                        Image(newRequest.region)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35)
                        
                        Image(systemName: "chevron.up.chevron.down")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.secondary)
                            .scaledToFit()
                            .frame(width: 10)
                    }
                }
                .sheet(isPresented: $showModal) {
                    RegionSelect(alpha2Bind: $newRequest.region)
                }
            }
        }
        .navigationTitle(newRequest.game)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        await appData.insertUserRequest(newRequest: newRequest)
                        _ = await appData.fetchUserRequests()
                    }
                    dismiss()
                } label: {
                    Text("Save and Exit")
                }
            }
        }
    }
}

struct GameConfig_Previews: PreviewProvider {
    static var previews: some View {
        GameSelection(appData: AppData())
    }
}
