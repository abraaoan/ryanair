//
//  Services.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 21/10/21.
//

import Foundation

class Services: NSObject {

    static func searchAvailability(origin: String, destination: String, dateout: String, dateIn: String, adt: String = "1", teen: String = "0", chd: String = "0", completion: @escaping ([Trip]?) -> ()) {
        
        let availabilityRouter = Router.searchAvailability(origin: origin,
                                                    destination: destination,
                                                    dateout: dateout,
                                                    dateIn: dateIn,
                                                    adt: adt,
                                                    teen: teen,
                                                    chd: chd)
        let abrequest = ABRequest()
        
        do {
            
            print(try availabilityRouter.request()?.url?.absoluteURL ?? "-")
            
            guard let request = try availabilityRouter.request() else {
                return
            }
            
            abrequest.requestObject(of: Availability.self, request: request) { (result) in
                switch result {
                case .success(let availability):
                    
                    let availability = availability as? Availability
                    
                    completion(availability?.trips)
                case .failure(let error):
                    completion(nil)
                    print("[Service]: parser error. \(error.localizedDescription)")
                }
            }
        } catch let error {
            completion(nil)
            print("[Service]: \(error.localizedDescription)")
        }
    }
   
    static func getStations(completion: @escaping ([Station]?) -> ()) {
        
        let availabilityRouter = Router.getStations
        let abrequest = ABRequest()
        
        do {
            guard let request = try availabilityRouter.request() else {
                return
            }
            
            abrequest.requestObject(of: StationResult.self, request: request) { (result) in
                switch result {
                case .success(let result):
                    
                    let stationsResult = result as? StationResult
                    completion(stationsResult?.stations)
                case .failure(let error):
                    completion(nil)
                    print("[Service]: parser error. \(error)")
                }
            }
        } catch let error {
            completion(nil)
            print("[Service]: \(error.localizedDescription)")
        }
    }
    
}
