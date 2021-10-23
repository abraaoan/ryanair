//
//  TripDateViewModel.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 23/10/21.
//

import UIKit

class TripDateViewModel: NSObject {
    
    var tripDate: TripDate?
    var date: String?
    var week: String?
    var price: String?
    var isSelected: Bool = false
    
    init(tripDate: TripDate) {
        super.init()
        
        self.tripDate = tripDate
        
        // Real Object Date
        let tDate = Utils.getDateAPIFormat(tripDate.dateOut)
        self.date = Utils.getDayMonth(tDate)
        self.week = Utils.getWeekName(tDate)
        
        // Getting price
        let firstFlight = tripDate.flights.first
        guard let rFares = firstFlight?.regularFare else { return }
        guard let firstFare = rFares.fares.first else { return }
        
        self.price = "€ \(firstFare.amount ?? 0.00)"
    }
    
}
