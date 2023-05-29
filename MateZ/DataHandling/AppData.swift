//
//  TempData.swift
//  MateZ
//
//  Created by Giuseppe Rocco on 29/04/23.
//

import Foundation

let mainRegions = ["ABW", "AFG", "AGO", "AIA", "ALA", "ALB", "AND", "ARE", "ARG", "ARM", "ASM", "ATA", "ATF", "ATG", "AUS", "AUT", "AZE", "BDI", "BEL", "BEN", "BES", "BFA", "BGD", "BGR", "BHR", "BHS", "BIH", "BLM", "BLR", "BLZ", "BMU", "BOL", "BRA", "BRB", "BRN", "BTN", "BVT", "BWA", "CAF", "CAN", "CCK", "CHE", "CHL", "CHN", "CIV", "CMR", "COD", "COG", "COK", "COL", "COM", "CPV", "CRI", "CUB", "CUW", "CXR", "CYM", "CYP", "CZE", "DEU", "DJI", "DMA", "DNK", "DOM", "DZA", "ECU", "EGY", "ERI", "ESH", "ESP", "EST", "ETH", "FIN", "FJI", "FLK", "FRA", "FRO", "FSM", "GAB", "GBR", "GEO", "GGY", "GHA", "GIB", "GIN", "GLP", "GMB", "GNB", "GNQ", "GRC", "GRD", "GRL", "GTM", "GUF", "GUM", "GUY", "HKG", "HMD", "HND", "HRV", "HTI", "HUN", "IDN", "IMN", "IND", "IOT", "IRL", "IRN", "IRQ", "ISL", "ISR", "ITA", "JAM", "JEY", "JOR", "JPN", "KAZ", "KEN", "KGZ", "KHM", "KIR", "KNA", "KOR", "KWT", "LAO", "LBN", "LBR", "LBY", "LCA", "LIE", "LKA", "LSO", "LTU", "LUX", "LVA", "MAC", "MAF", "MAR", "MCO", "MDA", "MDG", "MDV", "MEX", "MHL", "MKD", "MLI", "MLT", "MMR", "MNE", "MNG", "MNP", "MOZ", "MRT", "MSR", "MTQ", "MUS", "MWI", "MYS", "MYT", "NAM", "NCL", "NER", "NFK", "NGA", "NIC", "NIU", "NLD", "NOR", "NPL", "NRU", "NZL", "OMN", "PAK", "PAN", "PCN", "PER", "PHL", "PLW", "PNG", "POL", "PRI", "PRK", "PRT", "PRY", "PSE", "PYF", "QAT", "REU", "ROU", "RUS", "RWA", "SAU", "SDN", "SEN", "SGP", "SGS", "SHN", "SJM", "SLB", "SLE", "SLV", "SMR", "SOM", "SPM", "SRB", "SSD", "STP", "SUR", "SVK", "SVN", "SWE", "SWZ", "SXM", "SYC", "SYR", "TCA", "TCD", "TGO", "THA", "TJK", "TKL", "TKM", "TLS", "TON", "TTO", "TUN", "TUR", "TUV", "TWN", "TZA", "UGA", "UKR", "UMI", "URY", "USA", "UZB", "VAT", "VCT", "VEN", "VGB", "VIR", "VNM", "VUT", "WLF", "WSM", "YEM", "ZAF", "ZMB", "ZWE"]

@MainActor
class AppData: ObservableObject {
    private let webAPI: WebAPI = WebAPI()
    
    @Published var authData: LocalAuthData = LocalAuthData()
    @Published var localProfile: UserProfile = UserProfile()
    @Published var games: [String: Game] = [:]
    @Published var requests: [String: UserRequest] = [:]
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("macroclient.data")
    }
    
    func load() async throws {
        let task = Task<LocalAuthData, Error> {
            let fileURL = try Self.fileURL()

            guard let data = try? Data(contentsOf: fileURL) else {
                return LocalAuthData()
            }
            let authData = try JSONDecoder().decode(LocalAuthData.self, from: data)
            return authData
        }
        
        let taskValue = try await task.value
        self.authData = taskValue
    }


    func save() async throws {
        let task = Task {
            let data = try JSONEncoder().encode(self.authData)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
    
    func updateUser() async {
        do {
            let _ = try await webAPI.updateUser(token: authData.token, profile: localProfile)
        } catch {
            print("Error updating profile \(String(describing: error))")
        }
    }
    
    func getProfile(username: String) async -> UserProfile? {
        do {
            return try await webAPI.getProfile(username: username)
        } catch {
            print("Error retrieving profile \(username) \(String(describing: error))")
            return nil
        }
    }
    
    func logout() async {
        do {
            let _ = try await webAPI.logout(username: authData.username)
            authData.token = "na"; authData.username = "na"
        } catch {
            print("Error loggin user out \(String(describing: error))")
        }
    }
    
    func lastsession() async -> String {
        do {
            return try await webAPI.lastsession(username: authData.username, token: authData.token)
        } catch {
            print("Error authenticating user \(String(describing: error))")
            return "Error"
        }
    }
    
    func signin(username: String, password: String) async -> String {
        do {
            let response = try await webAPI.signin(username: username, password: password)
            
            if !response.contains("Invalid") {
                authData.token = response; authData.username = username
            }
            
            return response
        } catch {
            print("Error authenticating user \(String(describing: error))")
            return "Error"
        }
    }
    
    func signup(username: String, password: String) async -> String {
        do {
            return try await webAPI.signup(username: username, password: password)
        } catch {
            print("Error authenticating user \(String(describing: error))")
            return "Error"
        }
    }
    
    func insertUserRequest(newRequest: UserRequest) async {
        do {
            let _: String = try await webAPI.insert(authToken: authData.token, newRequest: newRequest)
        } catch {
            print("Error inserting user request \(String(describing: error))")
        }
    }
    
    func deleteUserRequest(uuid: String) async {
        do {
            let answer: String = try await webAPI.delete(authToken: authData.token, uuid: uuid)
            
            if answer == "Success" {
                let _ = await fetchUserRequests()
            }
        } catch {
            print("Error deleting request with uuid: \(uuid) \(String(describing: error))")
        }
    }
    
    func fetchUserRequests() async -> Bool {
        do {
            let tmp: [String: UserRequest] = try await webAPI.requests()
            requests = tmp
            return true
        } catch {
            print("Error fetching user requests \(String(describing: error))")
        }
        
        return false
    }
    
    func fetchRemoteGames() async {
        do {
            let tmp: [String: Game] = try await webAPI.games()
            games = tmp
        } catch {
            print("Error fetching remote games \(String(describing: error))")
        }
    }
}
