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
import SVProgressHUD

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    var username = ""
    var email = ""
    var password = ""
    var confirmedP = ""
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        
        self.hideKeyboardWhenTappedAround()
        
        
    }
    @IBAction func addImage(_ sender: UIButton) {
        print("Add image Pressed")
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        username = userName.text ?? "test1"
        email = emailField.text ?? "test1@mail.com"
        password = passwordField.text ?? "test1"
        
        let params : [ String : Any ] = ["name": username,
                                         "email": email,
                                         "password": password]
        print(params)
        print("Register Pressed")
        alamoResiterPost(with : params)

    }
    //Make a post request and received the bearer token to login to dashboard
    func alamoResiterPost(with parameter: [String:Any]) {
        
        let url = globalData.registerURL
        SVProgressHUD.show(withStatus: "Sending details")
        Alamofire.request( url , method: .post, parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let data = response.data {
                    do{
                        let json = try JSON(data: data)
                        globalData.authToken = json["token"].string!
                        print("Set auth token")
                        SVProgressHUD.dismiss()
                        self.AlamogetGetDashboard()
                    } catch{
                        print("Server sent no data for login")
                        SVProgressHUD.dismiss()
                    }
                }
        }
    }
    
    //MARK:- Makes a request to gewt
    func AlamogetGetDashboard()  {
        let bearer = "Bearer " + globalData.authToken
        let headers: HTTPHeaders = [
            "Authorization": bearer,
            "Accept": "application/json"
        ]
        SVProgressHUD.show(withStatus: "Fetching Dash data")
        
        Alamofire.request( globalData.dashboardURL , method: .post, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                if let data = response.data {
                    do{
                        let dashboardData = parseDashboard(with: data)
                        SVProgressHUD.dismiss()
                        self.instantiateDashboard(with: dashboardData)
                    }
                }
                else {
                    SVProgressHUD.dismiss()
                }
        }
    }
    
    
    func instantiateDashboard(with dashData: UserDashboard) {
        let vc = MapViewController(nibName: "MapViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let userPickeDImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        profileImage.image = userPickeDImage
        imagePicker.dismiss(animated: true, completion: nil)
    }
}


