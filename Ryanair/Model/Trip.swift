//
//  Trip.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 21/10/21.
//

struct Trip: Codable {
    let origin: String
    let originName: String
    let destinationName: String
    let dates: [TripDate]
    
    
}
