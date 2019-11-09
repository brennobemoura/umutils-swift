//
//  AlertController.swift
//  mercadoon
//
//  Created by brennobemoura on 26/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit
import UIContainer

extension AlertView {
    class Container: ContainerView<AlertView> {
        override func spacer<T>(_ view: T) -> Spacer where T : UIView {
            return .init({
                let contentView = UIView()

                if #available(iOS 11.0, *) {
                    contentView.insetsLayoutMarginsFromSafeArea = true
                }
                
                if let fadeView = self.view.fadeView {
                    contentView.addSubview(fadeView) { maker, _ in
                        maker.edges.equalTo(0)
                    }
                }
                
                if self.view.useBlur {
                    contentView.addSubview(Blur(blur: self.view.blurEffectStyle)) { maker, _ in
                        maker.edges.equalTo(0)
                    }
                }
                
                contentView.addSubview(Content.Center(
                    Rounder(view, radius: view.layer.cornerRadius)
                )) { maker, superview in
                    maker.top.equalTo(superview.snp.topMargin)
                    maker.bottom.equalTo(superview.snp.bottomMargin)
                    maker.leading.trailing.equalTo(0)
                }
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnBackground))
                contentView.addGestureRecognizer(tap)
                
                return contentView
            }(), spacing: 0)
        }
        
        @objc func tapOnBackground() {
            guard self.view.actions.isEmpty else {
                return
            }
            
            self.parent.dismiss(animated: true, completion: nil)
        }

        override func containerDidLoad() {
            super.containerDidLoad()

            if #available(iOS 11.0, *) {
                self.insetsLayoutMarginsFromSafeArea = true
            }
        }
    }
}

extension AlertView: ViewControllerType {
    public var content: ViewControllerMaker {
        .dynamic {
            $0.view.addSubview(AlertView.Container.init(in: $0, loadHandler: { self })) { maker, _ in
                maker.edges.equalTo(0)
            }
        }
    }
    
    @objc func tapOnBackground() {
        guard !self.actions.isEmpty else {
            return
        }
        
        self.parent.dismiss(animated: true, completion: nil)
    }
}

import SnapKit
extension UIView {
    func addSubview(_ view: UIView, maker: (ConstraintMaker, UIView) -> Void) {
        self.addSubview(view)
        view.snp.makeConstraints {
            maker($0, self)
        }
    }
}
