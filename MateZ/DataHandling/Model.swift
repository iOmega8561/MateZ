//
//  Model.swift
//  MacroClient
//
//  Created by Giuseppe Rocco on 25/04/23.
//
import Foundation

struct LocalAuthData: Codable {
    var token: String = "na"
    var username: String = "na"
}

struct FavouriteGame: Codable, Hashable {
    var name: String
    var plat: [String]
}

struct UserProfile: Codable {
    var username: String = "na"
    var avatar: String = "user_generic"
    var region: String = "na"
    var fgames: [FavouriteGame] = []
}

struct Game: Codable, Hashable {
    var name: String
    var imgname: String
    var plat: [String]
    var modes: [String]
    var skills: [String]
}

struct ServerGames: Codable {
    var games: [String: Game]
}

struct UserRequest: Codable, Hashable {
    var uuid: String
    var user_id: String
    var game: String
    var time: Int
    var mic: Bool
    var region: String
    var pnumber: Int
    var skills: [String]
    var plat: String
    var mode: String
    var date: Date
}

class ServerRequests: Codable {
    var requests: [String: UserRequest]
}

struct SimpleResponse: Codable {
    var answer: String
}
