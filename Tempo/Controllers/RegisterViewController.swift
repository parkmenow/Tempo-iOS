//
//  RegisterViewController.swift
//  Tempo
//
//  Created by bharath on 2019/02/23.
//  Copyright © 2019 shitian.ni. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    var username = ""
    var email = ""
    var password = ""
    var confirmedP = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        
    }
    @IBAction func addImage(_ sender: UIButton) {
        print("Add image Pressed")
        
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        username = userName.text ?? "test1"
        email = emailField.text ?? "test1@mail.com"
        password = passwordField.text ?? "test1"
        
        let params : [ String : Any ] = ["name": username,
                                         "email": email,
                                         "password": password]
//        alamoResiterPost(with : params)
        print(params)
        print("Register Pressed")
    }
    
    
    
    //Make a post request and received the bearer token to login to dashboard
    func alamoResiterPost(with parameter: [String:Any]) {
        
        
        
    }
    
    //MARK:- Makes a request to gewt
    func AlamogetGetDashboard(with token: String )  {
        let bearer = "Bearer " + token
        let headers: HTTPHeaders = [
            "Authorization": bearer,
            "Accept": "application/json"
        ]
        
        Alamofire.request( globalData.dashboardURL , method: .post, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                if let data = response.data {
                    do{
                        let dashboardData = parseDashboard(with: data)
                        self.instantiateDashboard(with: dashboardData)
                        
                    }
                }
        }
        
        
    }
    
    
    func instantiateDashboard(with dashData: UserDashboard) {
        
        
        
    }
}


