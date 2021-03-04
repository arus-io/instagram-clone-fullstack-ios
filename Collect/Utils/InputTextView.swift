//
//  InputTextView.swift
//  Collect
//
//  Created by Patrick Ortell on 2/1/21.
//

import UIKit

class InputTextView: UITextView {
    
    
    var placeholderText: String? {
        didSet { placeHolderLabel.text = placeholderText }
    }
     let placeHolderLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .lightGray
        
        return label
    }()
    
    var placeHolderShouldCenter = true  {
        didSet {
            if placeHolderShouldCenter {
                placeHolderLabel.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 9)
                placeHolderLabel.centerY(inView: self)
            }else {
                placeHolderLabel.anchor(top: topAnchor, left:leftAnchor, paddingTop: 6, paddingLeft: 8)

            }
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeHolderLabel)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func handleTextDidChange() {
        placeHolderLabel.isHidden = !text.isEmpty
    }
}
