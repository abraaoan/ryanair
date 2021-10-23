//
//  Dates.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 21/10/21.
//

import Foundation

struct TripDate: Codable {
    let dateOut: String
    let flights: [Flight]
}
