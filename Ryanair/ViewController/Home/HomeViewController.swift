//
//  ViewController.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 21/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    var stations: [Station]?
    var currentDates: [Date]?
    var currentDestination: Station?
    var currentOrigin: Station?
    var adultPassenger: Int = 1
    var teenPassenger: Int = 0
    var childrenPassenger: Int = 0
    
    var tripDates: [TripDateViewModel]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    var selectFlights: [FlightViewModel]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                let index: IndexSet = [0]
                self?.tableView.reloadSections(index, with: .fade)
            }
        }
    }
    
    @IBOutlet weak var txtDestination: UITextField!
    @IBOutlet weak var txtOrigin: UITextField!
    @IBOutlet weak var txtDepart: UITextField!
    @IBOutlet weak var txtReturn: UITextField!
    @IBOutlet weak var txtPassenger: UITextField!
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var btnSerach: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var formHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        self.formHeightConstraint = self.formView.constraintWithIdentifier("formHeightContraint")
        self.formHeightConstraint.constant = 0
        
        //
        self.spinnerView.isHidden = false
        self.collectionView.isHidden = true
        
        //
        Services.getStations { [weak self] stations in
            DispatchQueue.main.async {
                self?.spinnerView.isHidden = true
                self?.stations = stations
                self?.showFirstFields()
            }
        }
        
        //
        self.btnSerach.alpha = 0.5
        self.btnSerach.isEnabled = false
        
        //
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func showFirstFields() {
        
        if self.formHeightConstraint.constant > 0 { return }
        
        formHeightConstraint?.constant = 118
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func showMoreFields() {
        
        if self.formHeightConstraint.constant > 118 { return }
        if (self.txtOrigin.text?.isEmpty ?? true) { return }
        
        formHeightConstraint?.constant = 244
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { [weak self] finished in
            self?.navigateToCalendar()
        }
    }
    
    func shouldEnableSearh() {
        
        if (self.txtOrigin.text?.isEmpty ?? true) { return }
        if (self.txtDestination.text?.isEmpty ?? true) { return }
        if (self.txtDepart.text?.isEmpty ?? true) { return }
        if (self.txtReturn.text?.isEmpty ?? true) { return }
        if (self.txtPassenger.text?.isEmpty ?? true) { return }
        
        //
        self.btnSerach.alpha = 1
        self.btnSerach.isEnabled = true
        
    }
    
    func clearSelection() {
        self.tripDates?.forEach({$0.isSelected = false})
    }
    
    // - MARK: Actions
    
    @IBAction func selectFrom() {
        self.navigateToStations()
    }
    
    @IBAction func selectTo() {
        self.navigateToStations(from: false)
    }
    
    @IBAction func selectDepartReturn() {
        self.navigateToCalendar()
    }
    
    @IBAction func selectPassenger() {
        self.navigateToPassengers()
    }
    
    @IBAction func doSearch() {
        
        guard let origin = self.currentOrigin?.code else { return }
        guard let destination = self.currentDestination?.code else { return }
        guard let dateoutRaw = self.currentDates?.first else { return }
        guard let dateInRaw = self.currentDates?.last else { return }
        
        let dateout = Utils.getStringDateFormatedForURL(dateoutRaw)
        let datein = Utils.getStringDateFormatedForURL(dateInRaw)
        
        // Must get from new view
        let adt = "\(adultPassenger)"
        let teen = "\(teenPassenger)"
        let chd = "\(childrenPassenger)"
        
        self.spinnerView.isHidden = false
        self.btnSerach.alpha = 0.8
        self.btnSerach.setTitle("Searching...", for: .normal)
        self.btnSerach.isHidden = false
        
        //
        Services.searchAvailability(origin: origin,
                                    destination: destination,
                                    dateout: dateout,
                                    dateIn: datein,
                                    adt: adt,
                                    teen: teen,
                                    chd: chd) { trips in
            
            // Depart
            if let firstTrip = trips?.first {
                self.tripDates = firstTrip.dates.map({
                    let dateOut = self.currentDates?.first ?? Date()
                    let tDate = Utils.getDateAPIFormat($0.dateOut)
                    
                    let viewModel = TripDateViewModel(tripDate: $0)
                    if Utils.dateIsByDays(date: dateOut, isEqual: tDate) {
                        viewModel.isSelected = true
                        self.selectFlights = $0.flights.map({FlightViewModel(flight: $0)})
                    }
                    return viewModel
                })
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.spinnerView.isHidden = true
                
                self?.btnSerach.alpha = 1
                self?.btnSerach.setTitle("Search", for: .normal)
                self?.btnSerach.isEnabled = true
                
                //
                self?.collectionView.isHidden = false
                guard let selectedDate = self?.tripDates?.first(where: { $0.isSelected }) else { return }
                guard let index = self?.tripDates?.firstIndex(of: selectedDate) else { return }
                let indexPath = IndexPath(row: index, section: 0)
                
                self?.collectionView.scrollToItem(at: indexPath,
                                                  at: .centeredHorizontally,
                                                  animated: true)
                
                
                
            }
        }
    }
    
    // - MARK: Navigation
    
    func navigateToStations(from: Bool = true) {
        
        if !self.spinnerView.isHidden { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "StationsViewController")
        
        if let stationsViewController = viewController as? StationsViewController {
            stationsViewController.stations = self.stations
            stationsViewController.isFrom = from
            
            stationsViewController.onSelectStation = { [weak self] station in
                
                let value = "\(station.name), \(station.countryName)"
                
                if stationsViewController.isFrom {
                    self?.txtOrigin.text = value
                    self?.currentOrigin = station
                } else {
                    self?.txtDestination.text = value
                    self?.currentDestination = station
                }
                
                self?.shouldEnableSearh()
            }
            
            stationsViewController.onStationClose = { [weak self] in
                if !stationsViewController.isFrom {
                    self?.showMoreFields()
                }
            }
            
            self.present(stationsViewController, animated: true)
        }
    }
    
    func navigateToCalendar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "CalendarViewController")
        
        guard let calendarVC = viewController as? CalendarViewController else {
            return
        }
        
        calendarVC.selectDates = self.currentDates
        calendarVC.onSelectDates = { [weak self] dates in
            self?.currentDates = dates
            
            guard let depart = dates.first else { return }
            guard let retrn = dates.last else { return }
            
            self?.txtDepart.text = Utils.getStringDateFormated(depart)
            self?.txtReturn.text = Utils.getStringDateFormated(retrn)
            
            self?.shouldEnableSearh()
            
        }
        
        self.present(calendarVC, animated: true)
    }
    
    func navigateToPassengers() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "PassengersViewController")
        
        guard let passengersVC = viewController as? PassengersViewController else {
            return
        }
        
        passengersVC.adultsPassenger = self.adultPassenger
        passengersVC.teenPassenger = self.teenPassenger
        passengersVC.childrenPassenger = self.childrenPassenger
        
        passengersVC.onSelect = { [weak self] adl, tnn, chld in
            self?.adultPassenger = adl
            self?.teenPassenger = tnn
            self?.childrenPassenger = chld
            
            let others = tnn + chld
            
            self?.txtPassenger.text = others > 0 ? "\(adl) Adults, \(others) Other" : "\(adl) Adults"
            
        }

        self.present(passengersVC, animated: true)
        
    }
}

