//
//  StationsViewController.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 21/10/21.
//

import UIKit

class StationsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var value = ""
    var isFrom: Bool!
    var stations: [Station]? {
        didSet {
            self.filterStations = self.stations ?? [Station]()

            DispatchQueue.main.async {
                let sections: IndexSet = [0]
                self.tableView?.reloadSections(sections, with: .fade)
            }
        }
    }
    var filterStations = [Station]() {
        didSet {
            DispatchQueue.main.async {
                let sections: IndexSet = [0]
                self.tableView?.reloadSections(sections, with: .fade)
            }
        }
    }
    var onSelectStation: ((Station) -> ())?
    var onStationClose: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Avoid extras separators
        self.tableView.tableFooterView = UIView(frame: .zero)
        //
        self.textField.placeholder = "Inform your a \(isFrom ? "origin" : "destination")"
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textField.becomeFirstResponder()
        
    }
    
    // - MARK: - Navigation
    
    @IBAction func back() {
        self.dismiss(animated: true) {
            if let onClose = self.onStationClose {
                onClose()
            }
        }
    }
    
}

extension StationsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.length > 0 {
            
            // Clear all
            if (textField.text ?? "").count == 1 {
                self.value = ""
                self.filterStations = self.stations ?? [Station]()
            }
            
            return true
        }
        
        guard let datas = self.stations else { return true }
        value = (textField.text ?? "") + string
        value = value.trimmingCharacters(in: .whitespaces)
        
        filterStations.removeAll()
        
        let pattern = "\\b" + NSRegularExpression.escapedPattern(for: value)
        filterStations = datas.filter {
            let name = "\($0.name), \($0.countryName)"
            return name.folding(options: .diacriticInsensitive,
                            locale: .current).range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
        }
        
        if filterStations.isEmpty {
            filterStations = [Station]()
        }
        
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
}

extension StationsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "idCell") else { return UITableViewCell() }
        
        let station = self.filterStations[indexPath.row]
        cell.textLabel?.text = "\(station.name), \(station.countryName)"
        
        return cell
    }
}

extension StationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let onSelect = self.onSelectStation else { return }
        let station = self.filterStations[indexPath.row]
        onSelect(station)
        self.back()
    }
}
