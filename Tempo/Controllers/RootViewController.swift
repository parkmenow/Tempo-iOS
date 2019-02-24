//
//  RootViewController.swift
//  Tempo
//
//  Created by bharath on 2019/02/23.
//  Copyright © 2019 shitian.ni. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var imageStart: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func LoginPressed(_ sender: UIButton) {
        
//        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    @IBAction func RegisterPressed(_ sender: UIButton) {
//        performSegue(withIdentifier: "goToRegister", sender: self)
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
