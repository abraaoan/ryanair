//
//  Flight.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 21/10/21.
//

struct Flight: Codable {
    let regularFare: RegularFare
    let segments: [Segment]
    let flightNumber: String
    let time: [String]
    let timeUTC: [String]
    let duration: String
}

struct RegularFare: Codable {
    let fareClass: String
    let fares: [Fare]
}

struct Fare: Codable {
    let type: String?
    let amount: String?
    let count: String?
    let hasDiscount: Bool?
    let publishedFare: Float?
    let discountInPercent: Float?
    let hasPromoDiscount: Bool?
    let discountAmount: Float?
    let hasBogof: Bool?
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try? values.decode(String.self, forKey: .type)
        self.amount = try? values.decode(String.self, forKey: .amount)
        self.count = try? values.decode(String.self, forKey: .count)
        self.hasDiscount = try? values.decode(Bool.self, forKey: .hasDiscount)
        self.publishedFare = try? values.decode(Float.self, forKey: .publishedFare)
        self.discountInPercent = try values.decode(Float.self, forKey: .discountInPercent)
        self.discountAmount = try? values.decode(Float.self, forKey: .discountAmount)
        self.hasPromoDiscount = try? values.decode(Bool.self, forKey: .hasPromoDiscount)
        self.hasBogof = try? values.decode(Bool.self, forKey: .hasPromoDiscount)
    }
    
}

struct Segment: Codable {
    let segmentNr: Int
    let origin: String
    let destination: String
    let flightNumber: String
    let time: [String]
    let timeUTC: [String]
    let duration: String
}
