//
//  UIViewController+FloatingPopupView.swift
//  CryptoCoins
//
//  Created by MeTaLlOiD on 16/10/24.
//

import Foundation
import UIKit

extension UIViewController {
    func showFloatingPopup(title: String, message: String) {
        let popup = FloatingPopupView(title: title, message: message)
        
        popup.frame = CGRect(x: 40, y: UIScreen.main.bounds.height / 2 - 100, width: UIScreen.main.bounds.width - 80, height: 200)
        
        view.addSubview(popup)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup(_:)))
        popup.okButton.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissPopup(_ sender: UITapGestureRecognizer) {
        if let button = sender.view as? UIButton {
            button.superview?.removeFromSuperview() 
        }
    }
}
