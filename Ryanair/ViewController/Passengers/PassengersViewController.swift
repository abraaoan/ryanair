//
//  PassengersViewController.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 22/10/21.
//

import UIKit

class PassengersViewController: UIViewController {
    
    @IBOutlet weak var lblAdults: UILabel!
    @IBOutlet weak var lblTeen: UILabel!
    @IBOutlet weak var lblChildren: UILabel!
    
    var adultsPassenger: Int = 1 {
        didSet {
            lblAdults?.text = "\(adultsPassenger)"
        }
    }
    var teenPassenger: Int = 0 {
        didSet {
            lblTeen?.text = "\(teenPassenger)"
        }
    }
    var childrenPassenger: Int = 0 {
        didSet {
            lblChildren?.text = "\(childrenPassenger)"
        }
    }
    
    var onSelect: ((Int, Int, Int) -> ())?
    
    enum TypePassenger: Int {
        case adult = 0
        case teen = 1
        case children = 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        lblAdults.text = "\(adultsPassenger)"
        lblTeen.text = "\(teenPassenger)"
        lblChildren.text = "\(childrenPassenger)"
        
    }
    
    @IBAction func increase(_ sender: UIButton) {
        
        let type = TypePassenger(rawValue: sender.tag)
        
        switch type {
        case .adult:
            adultsPassenger += 1
            
        case .teen:
            teenPassenger += 1
            
        case .children:
            childrenPassenger += 1
            
        case .none:
            break
        }
    }
    
    @IBAction func decrease(_ sender: UIButton) {
        
        let type = TypePassenger(rawValue: sender.tag)
        
        switch type {
        case .adult:
            if adultsPassenger < 1 { return }
            adultsPassenger -= 1
            lblAdults.text = "\(adultsPassenger)"
            
        case .teen:
            if teenPassenger < 1 { return }
            teenPassenger -= 1
            lblTeen.text = "\(teenPassenger)"
            
        case .children:
            if childrenPassenger < 1 { return }
            childrenPassenger -= 1
            lblChildren.text = "\(childrenPassenger)"
            
        case .none:
            break
        }
    }
    
    @IBAction func back() {
        self.onSelect?(adultsPassenger, teenPassenger, childrenPassenger)
        self.dismiss(animated: true)
    }

}
