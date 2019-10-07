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

final public class AlertController<AlertView: UMUtils.AlertView>: UIViewController {
    weak var container: ContainerView<AlertView>!
    
    // MARK: Background Blur
    var blurEffectStyle: UIBlurEffect.Style {
        return self.container.view.blurEffectStyle
    }
    
    var useBlur: Bool {
        return self.container.view.useBlur
    }
    
    private var blurView: UIVisualEffectView? = nil
    
    public init(alertView: AlertView) {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    
        self.prepareContainer(ContainerView<AlertView>(in: self, loadHandler: { alertView }))
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnBackground))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.container.view.useBlur {
            self.blurView = self.blurView ?? self.createBlurView()
        } else {
            self.blurView?.removeFromSuperview()
        }
        
        self.container.view.setNeedsLayout()
        
        if let fadeView = self.container.view.fadeView {
            self.view.insertSubview(fadeView, at: 0)
            fadeView.snp.makeConstraints { $0.edges.equalTo(0) }
        }
        
        self.container.superview?.backgroundColor = self.container.view.backgroundColor
        
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.blurView?.removeFromSuperview()
    }

    @objc
    private func tapOnBackground(sender: UITapGestureRecognizer) {
        guard self.container.view.actions.isEmpty else {
            return
        }

        if sender.state == .ended {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func prepareContainer(_ container: ContainerView<AlertView>) {
        self.container = container
        let rounder = Rounder(container, radius: container.view.layer.cornerRadius)
        self.view.addSubview(rounder)
        rounder.snp.makeConstraints {  make in
            make.top.leading.greaterThanOrEqualTo(0)
            make.bottom.trailing.lessThanOrEqualTo(0)
            make.centerY.equalTo(self.view.snp.centerY)
            make.centerX.equalTo(self.view.snp.centerX)
       }
    }
}

private extension AlertController {
    func createBlurView() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        blurEffectView.contentView.addSubview(vibrancyEffectView)

        vibrancyEffectView.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalTo(0)
        }

        self.view.insertSubview(blurEffectView, at: 0)
        blurEffectView.snp.makeConstraints { $0.edges.equalTo(0) }
        return blurEffectView
    }
}
