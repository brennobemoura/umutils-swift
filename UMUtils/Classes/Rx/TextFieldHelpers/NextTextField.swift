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

    private weak var prev: NextTextField?
    private var next: NextTextField?
    private let isOptional: Bool

    private weak var field: UITextField!
    private let disposeBag: DisposeBag = .init()
    private weak var button: UIButton!
    
    fileprivate init(_ field: UITextField!,_ isOptional: Bool, previous: NextTextField? = nil) {
        self.field = field
        self.prev = previous
        self.isOptional = isOptional
        self.startListening()
    }
    
    @discardableResult
    public func onNext(_ field: UITextField!, isOptional: Bool = false) -> NextTextField {
        self.next = NextTextField(field, isOptional, previous: self)
        return self.next!
    }

    private func startListening() {
        self.field?.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { _ in
                self.nextOrHit()
            }).disposed(by: self.disposeBag)
    }
    
    public static func start(_ field: UITextField, isOptional: Bool = false) -> NextTextField {
        return Root(field, isOptional)
    }

    private func becomeFirstResponder() {
        if !self.isAvailable {
            self.nextOrHit()
            return
        }
        
        self.field.becomeFirstResponder() ? () : self.nextOrHit()
    }

    @objc private func nextOrHit() {
        if let next = self.next {
            next.becomeFirstResponder()
            return
        }

        guard !self.hitIfNeeded() else  {
            return
        }

        self.root?.nextAvailable?.field?.becomeFirstResponder()
    }

    private static func root(in ref: NextTextField!) -> NextTextField.Root? {
        guard let ref = ref else {
            return nil
        }

        if let root = ref as? Root {
            return root
        }

        return Self.root(in: ref.prev)
    }

    private var root: NextTextField.Root? {
        return Self.root(in: self)
    }

    var isAvailable: Bool {
        return self.field?.text?.isEmpty ?? false
    }

    private func hitIfNeeded() -> Bool {
        guard let root = self.root else {
            return false
        }

        let canHit: Bool = {
            var root: NextTextField? = root
            while let next = root {
                if !next.isOptional && (next.isAvailable) {
                    return false
                }

                root = next.next
            }

            return true
        }()

        if canHit {
            self.root?.hitButton?.sendActions(for: .touchUpInside)
            return true
        }

        return false
    }

    public func andHit(on button: UIButton!) {
        self.button = button
    }
}

extension NextTextField {
    class Root: NextTextField {
        var hitButton: UIButton? {
            var ref: NextTextField? = self
            while let next = ref {
                if let button = next.button {
                    return button
                }

                ref = next.next
            }

            return nil
        }

        var nextAvailable: NextTextField? {
            var ref: NextTextField? = self
            while let next = ref {
                if next.isAvailable {
                    return next
                }

                ref = next.next
            }

            return nil
        }
    }
}
