//
//  NextTextField.swift
//  mercadoon
//
//  Created by brennobemoura on 23/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

public class NextTextField {
    private weak var field: UITextField!
    private var next: NextTextField?
    private let disposeBag: DisposeBag = .init()
    
    private init(_ field: UITextField!) {
        self.field = field
    }
    
    @discardableResult
    public func onNext(_ field: UITextField!) -> NextTextField {
        self.next = NextTextField(field)
        
        self.field?.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { _ in
                self.next?.becomeFirstResponder()
            }).disposed(by: disposeBag)
        
        return self.next!
    }
    
    public static func start(_ field: UITextField) -> NextTextField {
        return NextTextField(nil).onNext(field)
    }
    
    private func becomeFirstResponder() {
        if !(self.field.text?.isEmpty ?? false) {
            self.next?.becomeFirstResponder()
            return
        }
        
        self.field.becomeFirstResponder() ? () : self.next?.becomeFirstResponder()
    }
}
