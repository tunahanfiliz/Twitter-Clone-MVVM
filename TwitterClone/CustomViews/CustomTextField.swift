//
//  CustomTextField.swift
//  TwitterClone
//
//  Created by Ios Developer on 16.12.2022.
//

import UIKit

class CustomTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience init(isSecureText:Bool,keyboardT:UIKeyboardType,placeHolderText:String) {
        self.init(frame: .zero)
        set(isSecureText: isSecureText, keyboardT: keyboardT, placeHolderText: placeHolderText)
        
    }
    
    func configuration(){
        translatesAutoresizingMaskIntoConstraints = false
        attributedPlaceholder = NSAttributedString(string: "password",attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
        isSecureTextEntry = true
        
    }
    private func set(isSecureText:Bool,keyboardT:UIKeyboardType,placeHolderText:String){
        isSecureTextEntry = isSecureText
        keyboardType = keyboardT
        attributedPlaceholder = NSAttributedString(string: placeHolderText,attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
        
    }
}
