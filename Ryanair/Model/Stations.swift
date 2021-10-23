//
//  File.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 21/10/21.
//

import Foundation

struct StationResult: Codable {
    let stations: [Station]
}

struct Station: Codable {
    let code: String
    let name: String
    let alternateName: String?
    let alias: [String]
    let countryCode: String
    let countryName: String
    let countryAlias: String?
    let countryGroupCode: String
    let countryGroupName: String
    let timeZoneCode: String
    let latitude: String
    let longitude: String
    let mobileBoardingPass: Bool
    let markets: [Market]
    let notices: String?
    let tripCardImageUrl: String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.code = try values.decode(String.self, forKey: .code)
        self.name = try values.decode(String.self, forKey: .name)
        self.alternateName = try? values.decode(String.self, forKey: .alternateName)
        self.alias = try values.decode([String].self, forKey: .alias)
        self.countryCode = try values.decode(String.self, forKey: .countryCode)
        self.countryName = try values.decode(String.self, forKey: .countryName)
        self.countryAlias = try? values.decode(String.self, forKey: .countryAlias)
        self.countryGroupCode = try values.decode(String.self, forKey: .countryGroupCode)
        self.countryGroupName = try values.decode(String.self, forKey: .countryGroupName)
        self.timeZoneCode = try values.decode(String.self, forKey: .timeZoneCode)
        self.latitude = try values.decode(String.self, forKey: .latitude)
        self.longitude = try values.decode(String.self, forKey: .longitude)
        self.mobileBoardingPass = try values.decode(Bool.self, forKey: .mobileBoardingPass)
        self.markets = try values.decode([Market].self, forKey: .markets)
        self.tripCardImageUrl = try? values.decode(String.self, forKey: .tripCardImageUrl)
        self.notices = try? values.decode(String.self, forKey: .notices)
        
    }
    
}

struct Market: Codable {
    let code: String
    let group: String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.code = try values.decode(String.self, forKey: .code)
        self.group = try? values.decode(String.self, forKey: .group)
        
    }
}
