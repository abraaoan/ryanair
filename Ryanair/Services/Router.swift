//
//  Router.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 21/10/21.
//

import UIKit

enum Router {
    
    private static let baseUrl = "https://sit-nativeapps.ryanair.com/api/v4/Availability"
    
    private static let stationsUrl = "https://mobile-testassets-dev.s3.eu-west-1.amazonaws.com/stations.json"
    
    case getStations
    case searchAvailability(origin: String, destination: String, dateout: String, adt: String, teen: String, chd: String)
    
    private var path: String {
        
        switch self {
        case .getStations:
            return Router.stationsUrl
        case .searchAvailability:
            return "\(Router.baseUrl)?origin=:origin&destination=:destination&dateout=:dateout&datein=&flexdaysbeforeout=3&flexdaysout=3&flexdaysbeforein=3&flexdaysin=3&adt=:adt&teen=:teen&chd=:chd&roundtrip=false&ToUs=AGREED&Disc=0"
        }
    }
    
    func request() throws -> URLRequest? {
        switch self {
        case .getStations:
            guard let stationUrl = URL(string: self.path) else { throw ErrorType.urlFail }
            return ABRequest.makeRequest(url: stationUrl)
            
        case .searchAvailability(let origin, let destination, let dateout, let adt, let teen, let chd):
            
            var path = self.path.replacingOccurrences(of: ":origin", with: origin)
            path = self.path.replacingOccurrences(of: ":destination", with: destination)
            path = self.path.replacingOccurrences(of: ":dateout", with: dateout)
            path = self.path.replacingOccurrences(of: ":adt", with: adt)
            path = self.path.replacingOccurrences(of: ":teen", with: teen)
            path = self.path.replacingOccurrences(of: ":chd", with: chd)
            
            guard let availabilityUrl = URL(string: path) else { throw ErrorType.urlFail }
            return ABRequest.makeRequest(url: availabilityUrl)
        }
    }
    
}
