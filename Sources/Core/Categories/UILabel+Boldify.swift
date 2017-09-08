//
//  UILabel+Boldify.swift
//  SpaAtHome
//
//  Created by Ramon Vicente on 21/08/17.
//  Copyright © 2017 Spa At Home. All rights reserved.
//

import UIKit

extension UILabel {

    public func boldSubstring(_ substring: String) {
        self.attributedText = self.attributedText?.setAttributes([NSFontAttributeName: self.font.bold], string: substring)
    }
}