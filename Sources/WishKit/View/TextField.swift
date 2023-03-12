//
//  TextField.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/9/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

#if canImport(UIKit)
import UIKit

final class TextField: UITextField {
    
    private var padding: UIEdgeInsets
    
    init(padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)) {
        self.padding = padding
        super.init(frame: .zero)
        
        layer.cornerRadius = 12
        layer.cornerCurve = .continuous
        textColor = .label
        backgroundColor = .tertiarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Padding

extension TextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
#endif
