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
        
        
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        username = userName.text ?? "test1"
        email = emailField.text ?? "test1@mail.com"
        password = passwordField.text ?? "test1"
        
        let params : [ String : Any ] = ["name": username,
                                            "email": email,
                                            "password": password]
        alamoPost(with : params)
        
    }
    
    
    
    //Make a post request and received the bearer token to login to dashboard
    func alamoPost(with parameter: [String:Any]) {
        
        
        
    }
    
    //Makes a request to gewt
    func AlamogetDashboard(){
        
    }
    
}
