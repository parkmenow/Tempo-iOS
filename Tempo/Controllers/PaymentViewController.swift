//
//  PaymentViewController.swift
//  Tempo
//
//  Created by bharath on 2019/02/22.
//  Copyright © 2019 shitian.ni. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set GUI elements from passed data
        self.userIdentifier.text = user
        self.taxiIdentifier.text = taxi
        self.payTime.text = bookTime
        self.costLabel.text = cost + ""
        self.payMethodSwitch.isOn = payByCard

        
    }
    
    //
    @IBOutlet weak var userIdentifier: UILabel!
    @IBOutlet weak var taxiIdentifier: UILabel!
    @IBOutlet weak var payTime: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var payMethodSwitch: UISwitch!
    
    var user : String = ""
    var taxi : String = ""
    var bookTime : String = ""
    var cost : String = ""
    var payByCard : Bool = false
    
    
    @IBAction func payNowButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        if payByCard {
            //Call stripe
        } else {
            //Pay by wallet
        }
        
    }
    
}
