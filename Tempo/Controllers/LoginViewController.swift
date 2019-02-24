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
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        
        self.username.text = "test1"
        self.passwordField.text = "test1"

        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        print("Login Pressed")
        
        let name = username.text ?? ""
        let pass = passwordField.text ?? ""
        
        setTokenWithLogin(name: name, password: pass)
        
    }
    
    func setTokenWithLogin(name: String, password : String){
        
        let url = globalData.loginURL
        let params : [ String : Any] = ["u_name":name,
                                        "password":password
        ]
        
        do {
            print("logging in at ",url)
            Alamofire.request( url , method: .post, parameters: params, encoding: JSONEncoding.default)
                .responseJSON { response in
                    if let data = response.data {
                        do{
                            let json = try JSON(data: data)
                            globalData.authToken = json["token"].string!
                            print("Set auth token")
                            self.getDashData()
                        } catch{
                            print("Server sent no data for login")
                        }
                    }
            }
        }
    
    }
    
    func getDashData(){
        
        let bearer = "Bearer "+globalData.authToken
        
        let header: HTTPHeaders = [
            "Authorization": bearer,
            "Accept": "application/json"
        ]
        
        Alamofire.request( globalData.dashboardURL , method: .get , headers : header)
            .responseJSON { response in
                if let data = response.data {
                    do{
                        print("Got following data json from call to dashboard url")
                        print(response.result.value!)
                        globalData.user  = parseDashboard(with: data)
                        print("After Parsing")
                        print(globalData.user)
   
                        self.instantiateDashboard()
                    }
                }
        }
    }
    
    
    func instantiateDashboard(){
        
        
        let vc = MapViewController(nibName: "MapViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}





