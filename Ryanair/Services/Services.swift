//
//  Services.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 21/10/21.
//

import Foundation

class Services: NSObject {

    static func searchAvailability(origin: String, destination: String, dateout: String, adt: String, teen: String, chd: String, completion: @escaping (Any?) -> ()) {
        
        let booksRouter = Router.searchAvailability(origin: origin,
                                                    destination: destination,
                                                    dateout: dateout,
                                                    adt: adt,
                                                    teen: teen,
                                                    chd: chd)
        let abrequest = ABRequest()
        
        do {
            guard let request = try booksRouter.request() else {
                return
            }
            
            abrequest.requestObject(of: SearchResult.self, request: request) { (result) in
                switch result {
                case .success(let books):
                    completion(books as? SearchResult)
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
   
}
