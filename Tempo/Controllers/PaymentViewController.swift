//
//  PaymentViewController.swift
//  Tempo
//
//  Created by bharath on 2019/02/22.
//  Copyright © 2019 shitian.ni. All rights reserved.
//

import UIKit
import Alamofire

class PaymentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set GUI elements from passed data
        self.userIdentifier.text = globalData.user.Name
        self.taxiIdentifier.text = taxi
        self.payTime.text = bookTime
        self.costLabel.text = cost + "¥"
        self.payMethodSwitch.isOn = payByCard
    }
    
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
    var booking = Booking()
    var fare : Float = 0
    
    @IBAction func payNowButtonPressed(_ sender: Any) {
        
        //Make a POST request to production server
        let params : [String:Any] = ["Name":globalData.user.Name,
                                     "Fare":Int(fare),
                                     "Email":globalData.user.Email,
                                     "Walletpay":payMethodSwitch.isOn]
        alamoPost(with: params)
        
        
        
        
        
    }
    
    func alamoPost(with parameters: [String:Any]){
        
        let bearer = "Bearer "+globalData.authToken
        
        let header: HTTPHeaders = [
            "Authorization": bearer,
            "Accept": "application/json"
        ]
        Alamofire.request( globalData.paymentURL , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers : header)
            .responseString { response in
//                print("\(response.result.isSuccess)")
//                print("\(response.result.value!)")
                if response.result.isSuccess {
                    
                }
                
                self.createAlert(with: response.result.value!)
//                self.dismiss(animated: true, completion: nil)
        }
    }
    
    func createAlert(with text: String){
        let alert = UIAlertController(title: "Alert", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
