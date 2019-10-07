//
//  AlertView.swift
//  mercadoon
//
//  Created by brennobemoura on 26/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import SnapKit
import UIContainer

public class AlertView: View {
    private var stackView: UIStackView!
    private weak var spacer: Spacer!
    
    // MARK: Image Alert
    public private(set) var imageView: UIImageView? = nil

    open var imageHeight: CGFloat = 175 {
        willSet {
            if imageView != nil {
                self.updateHeight(self.imageView, height: newValue)
            }
        }
    }
    
    func updateHeight(_ view: UIView!, height: CGFloat) {
        view.snp.remakeConstraints { make in
            make.height.equalTo(height)
        }
    }
    
    open func createImage(_ image: UIImage) -> UIImageView {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.image = image
        return imgView
    }

    public func setImage(_ image: UIImage?) {
        guard let image = image else {
            self.imageView?.removeFromSuperview()
            self.imageView = nil
            return
        }

        if self.imageView == nil {
            self.imageView = self.createImage(image)
            self.updateHeight(self.imageView, height: self.imageHeight)
        } else {
            self.imageView?.image = image
        }

        self.stackView.insertArrangedSubview(self.imageView!, at: 0)
    }
    
    // MARK: Alert Title
    public private(set) var titleLabel: UILabel? = nil

    open func createTitle() -> UILabel {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.minimumScaleFactor = 0.65
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }

    public func setTitle(_ text: String?) {
        guard let text = text else {
            self.titleLabel?.removeFromSuperview()
            self.titleLabel = nil
            return
        }

        if self.titleLabel == nil {
            self.titleLabel = self.createTitle()
        }

        self.titleLabel?.text = text

        self.stackView.insertArrangedSubview(self.titleLabel!, at: self.position(for: 1))
    }
    
    // MARK: Alert Subtitle
    private(set) var textSV: UIStackView? = nil

    open func createTextSV() -> UIStackView {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }
    
    open func createText() -> UILabel {
        let lbl = UILabel()
        lbl.minimumScaleFactor = 0.65
        lbl.textColor = UIColor(red: 0.51, green: 0.54, blue: 0.58, alpha: 1.00)
        lbl.textColor = .gray
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }
    
    public func setText(_ text: String?, at index: Int? = nil) {
        guard let text = text else {
            self.textSV?.removeFromSuperview()
            self.textSV = nil
            return
        }
        
        let stackView = self.textSV ?? self.createTextSV()
        let label: UILabel = {
            if let index = index, let label = stackView.arrangedSubviews[index] as? UILabel {
                return label
            }
            
            return self.createText()
        }()
        
        self.textSV = stackView
        
        if let attributed = label.attributedText {
            label.attributedText = attributed
        } else {
            label.text = text
        }
        
        if label.superview == nil {
            stackView.insertArrangedSubview(label, at: stackView.subviews.count)
        }
        
        if stackView.superview == nil {
            self.stackView.insertArrangedSubview(stackView, at: self.position(for: 3))
        }
    }
    
    public final var textLabels: [UILabel] {
        return self.textSV?.arrangedSubviews.compactMap {
            $0 as? UILabel
        } ?? []
    }

    // MARK: Alert Text
    public private(set) var subtitleLabel: UILabel? = nil

    open func createSubtitle() -> UILabel {
        let lbl = UILabel()
        lbl.minimumScaleFactor = 0.65
        lbl.textColor = .lightGray
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }
    
    public func setSubtitle(_ text: String?) {
        guard let text = text else {
            self.subtitleLabel?.removeFromSuperview()
            self.subtitleLabel = nil
            return
        }

        if self.subtitleLabel == nil {
            self.subtitleLabel = self.createText()
        }

        self.subtitleLabel?.text = text

        self.stackView.insertArrangedSubview(self.subtitleLabel!, at: self.position(for: 2))
    }

    // MARK: Position calculate the index for alertContainer
    func position(for item: Int) -> Int {
        let array = [Any?]([
            self.imageView,
            self.titleLabel,
            self.subtitleLabel,
            self.textSV,
            self.actionSV
        ])

        let futureIndex = Array(array[0..<item]).reduce(0) { $0 + ($1 != nil ? 1 : 0) }
        return futureIndex >= self.stackView.arrangedSubviews.count ? self.stackView.arrangedSubviews.count : futureIndex
    }
    
    private let actionSV: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    var actions: [UIView] {
        return self.stackView.arrangedSubviews
    }

    open func addAction(action: AlertButton.Action) {
        if actionSV.superview == nil {
            self.stackView.addArrangedSubview(actionSV)
        }
        
        let view = action.asView()
        
        if let tapGesture = view.gestureRecognizers?.first(where: { $0 is UITapGestureRecognizer }) as? UITapGestureRecognizer {
            tapGesture.addTarget(self, action: #selector(self.tapOnAction(_:)))
        } else {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapOnAction(_:)))
            view.addGestureRecognizer(tapGesture)
        }
        
        actionSV.insertArrangedSubview(self.rounder(actionView: view), at: 0)
        view.snp.makeConstraints { $0.height.equalTo(44) }
    }
    
    open func rounder(actionView: UIView) -> Rounder {
        return .init(actionView, radius: 4)
    }

    @objc
    private func tapOnAction(_ sender: UIButton) {
        self.parent.dismiss(animated: true)
    }
    
    override public func prepare() {
        super.prepare()
        
        let stack = UIStackView()
        let spacer = Spacer(stack, spacing: self.margin)
        
        self.stackView = stack
        self.spacer = spacer
        
        stack.axis = .vertical
        stack.spacing = self.spacing
        
        self.addSubview(spacer)
        spacer.snp.makeConstraints { $0.edges.equalTo(0) }
        
        self.applyWidth()
        
    }
    
    var spacing: CGFloat {
        return 16
    }
    
    var margin: CGFloat {
        return spacing * 2
    }
    
    open var fadeView: UIView! {
        if self.useBlur {
            return nil
        }
        
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        return view
    }

    // MARK: Width configuration for flexible layout
    private class var defaultWidth: CGFloat {
        return 290
    }
    
    open var alertWidth: CGFloat = defaultWidth
    
    private final func applyWidth() {
        self.spacer.snp.makeConstraints { make in
            make.width.equalTo(alertWidth)
        }
    }
    
    open var actionButtonType: AlertButton.Action.Type {
        return AlertButton.Action.self
    }
    
    var blurEffectStyle: UIBlurEffect.Style = .regular
    
    var useBlur: Bool = false
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.applyPriorities()
    }
    
    func applyPriorities() {
        [self.titleLabel, self.subtitleLabel].forEach {
            $0?.applyHighPriority()
        }
        
        self.textSV?.arrangedSubviews.forEach {
            $0.applyHighPriority()
        }
    }
    
    override public var backgroundColor: UIColor? {
        get {
            return self.spacer.backgroundColor
        }
        
        set {
            self.spacer.backgroundColor = newValue
        }
    }
}

fileprivate extension UIView {
    func applyHighPriority() {
        self.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        self.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        self.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
}
