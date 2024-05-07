//
//  extension+UIViewController.swift
//  iOS Test
//
//  Created by Jose Jacob on 07/05/24.
//

import UIKit

extension UIViewController{
    func showOKAlert(_ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5){
            alert.dismiss(animated: true)
        }
    }
    func showDismissAlert(dismissDuration:Double = 0.5, _ title: String, _ message: String, completion:(()->Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+dismissDuration){
            alert.dismiss(animated: true)
            completion?()
        }
    }
}
