//
//  FlightViewModel.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 23/10/21.
//

import UIKit

class FlightViewModel: NSObject {
    
    var departTime: String?
    var arraveTime: String?
    var duration: String?
    var flightNumber: String?
    var price: String?
    
    init(flight: Flight) {
        super.init()
        
        let departDate = Utils.getDateAPIFormat(flight.time.first ?? "")
        let arraveDate = Utils.getDateAPIFormat(flight.time.last ?? "")
        
        self.departTime = Utils.getTimeFromDate(date: departDate)
        self.arraveTime = Utils.getTimeFromDate(date: arraveDate)
        self.flightNumber = flight.flightNumber
        self.duration = "Duration \(flight.duration)"
        
        let rFares = flight.regularFare
        guard let firstFare = rFares.fares.first else { return }
        
        self.price = "€ \(firstFare.amount ?? 0.00)"
        
    }
}
