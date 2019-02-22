//
//  RootViewController.swift
//  Tempo
//
//  Created by bharath on 2019/02/22.
//  Copyright © 2019 shitian.ni. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        
        print("Login Pressed")
        
        let vc = MapViewController(nibName: "MapViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
