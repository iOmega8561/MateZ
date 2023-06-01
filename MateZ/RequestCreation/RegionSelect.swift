//
//  RegionSelect.swift
//  MateZ
//
//  Created by Giuseppe Rocco on 31/05/23.
//

import SwiftUI

struct RegionSelect: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var alpha2Bind: String
    @State var searchText: String = ""
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return regions
                    .map{$0.key}
                    .sorted()
        } else {
            return regions
                    .map{$0.key}
                    .filter { $0.contains(searchText) }
                    .sorted()
        }
    }
    
    var body: some View {
        NavigationView {
            List(searchResults, id: \.self) { region in
                Button {
                    alpha2Bind = regions[region] ?? "na"
                    dismiss()
                } label: {
                    HStack(spacing: 10) {
                        Image(regions[region]!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35)
                        
                        Text(region)
                            .lineLimit(1)
                            .foregroundColor(.primary)
                        
                        if alpha2Bind == regions[region] ?? "na" {
                            Spacer()
                            Image(systemName: "checkmark")
                                .renderingMode(.template)
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Select a region")
            .navigationBarTitleDisplayMode(.inline)
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
    }
}

struct RegionSelect_Previews: PreviewProvider {
    static var previews: some View {
        RegionSelect(alpha2Bind: .constant(""))
    }
}
