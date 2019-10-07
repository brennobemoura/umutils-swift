//
//  PPEmptyView.swift
//  UMUtils-Swift
//
//  Created by brennobemoura on 01/06/19.
//  Copyright © 2019 Umobi. All rights reserved.
//

import UIKit
import SnapKit

public class EmptyView: UIView {
    public private(set) weak var titleLabel: UILabel!
    public private(set) weak var messageLabel: UILabel!
    
    private weak var actionContainer: UIView!
    public private(set) weak var actionButton: UIButton!
    
    private weak var imageContainer: UIView!
    public private(set) weak var imageView: UIImageView!
    
    private weak var stackView: UIStackView!
    
    public init() {
        super.init(frame: .infinite)
        self.setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.prepareStackView()
        self.prepareImageView()
        self.prepareTitle()
        self.prepareMessage()
        self.prepareAction()
        
        self.backgroundColor = .white
        
        self.stackView.arrangedSubviews.forEach {
            $0.isHidden = true
        }
    }
}

@objc
public extension EmptyView {
    
    func setTitle(_ title: String?) {
        self.titleLabel.text = title
        
        guard let title = title, !title.isEmpty else {
            self.titleLabel.isHidden = true
            return
        }
        
        self.titleLabel.isHidden = false
    }
    
    func setMessage(_ message: String?) {
        self.messageLabel.text = message
        
        guard let message = message, !message.isEmpty else {
            self.messageLabel.isHidden = true
            return
        }
        
        self.messageLabel.isHidden = false
    }
}

public extension EmptyView {
    
    func setImage(_ image: UIImage?) {
        self.imageView.image = image
        
        guard image != nil else {
            self.imageContainer.isHidden = true
            return
        }
        
        self.imageContainer.isHidden = false
    }
    
    struct Target {
        let sender: Any?
        let action: Selector
        let event: UIControl.Event
        
        public init(_ sender: Any?, action: Selector, for event: UIControl.Event) {
            self.sender = sender
            self.action = action
            self.event = event
        }
    }
    
    func setAction(_ title: String?, target: Target? = nil) {
        self.actionButton.setTitle(title, for: .normal)
        
        guard let title = title, !title.isEmpty else {
            self.actionButton.removeTarget(nil, action: nil, for: .allEvents)
            self.actionContainer.isHidden = true
            return
        }
        
        self.actionContainer.isHidden = false
        guard let target = target else {
            return
        }
        
        self.actionButton.removeTarget(nil, action: nil, for: .allEvents)
        self.actionButton.addTarget(target.sender, action: target.action, for: target.event)
    }
}

fileprivate extension EmptyView {
    func prepareStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        
        self.addSubview(stackView)
        self.stackView = stackView
        
        self.stackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(50)
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.bottom.lessThanOrEqualTo(-50)
        }
    }
}

fileprivate extension EmptyView {
    func createImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "SPCameraPickerLocked"))
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 3
        
        imageContainer.addSubview(imageView)
        
        return imageView
    }
    
    func prepareImageView() {
        let containerView = UIView()
        self.stackView.addArrangedSubview(containerView)
        self.imageContainer = containerView
        
        self.imageView = self.createImageView()
        
        self.imageContainer.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        self.imageView.snp.makeConstraints { make in
            make.width.height.equalTo(self.imageContainer.snp.height)
            make.center.equalTo(self.imageContainer.snp.center)
        }
        
        self.imageView.layer.cornerRadius = 50
    }
}

fileprivate extension EmptyView {
    func prepareTitle() {
        let title = UILabel()
        
        title.font = UIFont.boldSystemFont(ofSize: 24.0)
        title.textColor = .gray
        title.textAlignment = .center
        title.text = "Title content"
        title.numberOfLines = 0
        
        title.lockResizeLayout()
        
        self.stackView.addArrangedSubview(title)
        
        self.titleLabel = title
    }
    
    func prepareMessage() {
        let message = UILabel()
        
        message.font = UIFont.systemFont(ofSize: 16.0)
        message.textColor = .lightGray
        message.textAlignment = .center
        message.text = "Message content"
        message.numberOfLines = 0
        
        message.lockResizeLayout()
        
        self.stackView.addArrangedSubview(message)
        
        self.messageLabel = message
    }
}

fileprivate extension EmptyView {
    func createAction() -> UIButton {
        let button = UIButton()
        
        button.setTitle("Tentar Novamente", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        
        self.addSubview(button)
        
        return button
    }
    
    func prepareAction() {
        self.actionButton = self.createAction()
        
        let containerView = UIView()
        self.stackView.addArrangedSubview(containerView)
        self.actionContainer = containerView
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        containerView.addSubview(self.actionButton)
        
        self.actionButton.snp.makeConstraints { make in
            make.width.equalTo(210)
            make.leading.greaterThanOrEqualTo(0)
            make.trailing.lessThanOrEqualTo(0)
            make.centerX.equalTo(containerView.snp.centerX)
            make.top.bottom.equalTo(0)
        }
    }
}

fileprivate extension UIView {
    func lockResizeLayout() {
        self.setContentHuggingPriority(.required, for: .vertical)
        self.setContentHuggingPriority(.required, for: .horizontal)
        
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
