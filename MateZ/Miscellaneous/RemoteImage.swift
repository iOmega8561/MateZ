//
//  RemoteImage.swift
//  MateZ
//
//  Created by Giuseppe Rocco on 29/04/23.
//

import SwiftUI

struct RemoteImage: View {
    private let baseUrl: String = "https://test.example.domain.com"
    let imgname: String
    var squareSize: CGFloat?
    
    var body: some View {
        if UIImage(named: imgname) != nil {
            Image(imgname)
                .resizable()
                .scaledToFit()
                .frame(width: squareSize ?? 60)
        } else {
            AsyncImage(url: URL(string: "\(baseUrl)/img?name=\(imgname)")) { phase in
                switch phase {
                    
                case .empty:
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.accentColor))
                    Spacer()
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: squareSize ?? 60)
                    
                case .failure(_):
                    Spacer()
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Spacer()
                    
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(imgname: "game_generic")
    }
}
