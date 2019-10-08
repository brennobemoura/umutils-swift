//
//  MaskTextField.swift
//  mercadoon
//
//  Created by brennobemoura on 23/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

public class MaskTextField {
    private let mask: MaskType
    private weak var field: UITextField!
    private let disposeBag: DisposeBag = .init()
    
    public init(mask: MaskType) {
        self.mask = mask
    }
    
    public func onTextField(_ textField: UITextField!) {
        self.field = textField
        
        self.field.rx.text.startWith(textField.text)
            .subscribe(onNext: { text in
                let masked = text?.applyMask(self.mask)
                if masked != text {
                    self.field.text = masked
                }
            }).disposed(by: disposeBag)
    }
}
