//
//  HomeCollectionViewExtension.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 23/10/21.
//

import UIKit

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tripDates?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeDateCollectionViewCell",
                                                      for: indexPath) as! HomeDateCollectionViewCell
        
        let tripDate = self.tripDates?[indexPath.row]
        
        cell.lblDate.text = tripDate?.date
        cell.lblWeek.text = tripDate?.week
        cell.lblPrice.text = tripDate?.price
        
        cell.selectionView.isHidden = !(tripDate?.isSelected ?? false)
        
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let tripDate = self.tripDates?[indexPath.row] else { return }
        guard let flights = tripDate.tripDate?.flights else { return }
        self.selectFlights = flights.map({ FlightViewModel(flight: $0) })
        
        self.clearSelection()
        tripDate.isSelected = true
        self.collectionView.reloadData()
        self.scrollDatesToMiddle()
        
    }
    
}
