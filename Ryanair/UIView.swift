//
//  UIView.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 22/10/21.
//

import UIKit

extension UIView {
    
    /// Returns the first constraint with the given identifier, if available.
    ///
    /// - Parameter identifier: The constraint identifier.
    func constraintWithIdentifier(_ identifier: String) -> NSLayoutConstraint? {
        return self.constraints.first { $0.identifier == identifier }
    }
    
}
