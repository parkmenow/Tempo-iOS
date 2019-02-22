//
//  RootViewController.swift
//  Tempo
//
//  Created by bharath on 2019/02/22.
//  Copyright © 2019 shitian.ni. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class RootViewController: UIViewController {
    
    override func viewDidLoad() {

        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        print("Login Pressed")
     
        let vc = MapViewController(nibName: "MapViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

