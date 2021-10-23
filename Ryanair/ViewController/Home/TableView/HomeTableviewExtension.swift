//
//  HomeTableviewExtension.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 23/10/21.
//

import UIKit

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectFlights?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFilghtsTableViewCell",
                                                 for: indexPath) as! HomeFilghtsTableViewCell
        
        
        let flight = self.selectFlights?[indexPath.row]
        cell.lblDuration.text = flight?.duration
        cell.lblDepartTime.text = flight?.departTime
        cell.lblArraiveTime.text = flight?.arraveTime
        cell.lblFlightNumber.text = flight?.flightNumber
        cell.lblOriginStation.text = self.currentOrigin?.name
        cell.lblDestinationStation.text = self.currentDestination?.name
        cell.price.text = flight?.price
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
