//
//  Helpers.swift
//  On The Map
//
//  Created by Sergey on 21/2/20.
//  Copyright © 2020 Sergey. All rights reserved.
//
import Foundation
import UIKit

extension UIViewController {
    
     func displayAlert(title:String, message:String?) {
           if let message = message {
               let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertController.Style.alert)
               alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true)

           }
       }
}
