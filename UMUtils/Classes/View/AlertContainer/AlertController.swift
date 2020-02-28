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
import EasyAnchor

extension AlertView {
    class Container: ContainerView<AlertView> {
        override func spacer<T>(_ view: T) -> SpacerView where T : UIView {
            return .init({
                let contentView = UIView()

                if #available(iOS 11.0, *) {
                    contentView.insetsLayoutMarginsFromSafeArea = true
                }
                
                if let fadeView = self.view.fadeView {
                    AddSubview(contentView).addSubview(fadeView)

                    activate(
                        fadeView.anchor
                            .edges
                    )
                }
                
                if self.view.useBlur {
                    let blurView = BlurView(blur: self.view.blurEffectStyle)
                    AddSubview(contentView).addSubview(blurView)

                    activate(
                        blurView.anchor
                            .edges
                    )
                }

                let centerView = ContentView.Center(
                    RounderView(view, radius: view.layer.cornerRadius)
                )

                AddSubview(contentView).addSubview(centerView)

                activate(
                    centerView.anchor
                        .top
                        .equal.to(contentView.anchor.topMargin),

                    centerView.anchor
                        .bottom
                        .equal.to(contentView.anchor.bottomMargin),

                    centerView.anchor
                        .leading
                        .trailing
                        .equal
                        .constant(0)
                )
                
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
            let containerView = AlertView.Container.init(in: $0, loadHandler: { self })
            AddSubview($0.view).addSubview(containerView)

            activate(
                containerView.anchor
                    .edges
            )
        }
    }
    
    @objc func tapOnBackground() {
        guard !self.actions.isEmpty else {
            return
        }
        
        self.parent.dismiss(animated: true, completion: nil)
    }
}
