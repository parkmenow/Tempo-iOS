//
//  userDashboard.swift
//  Tempo
//
//  Created by bharath on 2019/02/23.
//  Copyright © 2019 shitian.ni. All rights reserved.
//

import Foundation

struct UserDashboard: Codable {
    var Name : String
    var Wallet: Int
    var imageURL : String?
    var Email : String
    var Phone : String
    
    
    init(){
        self.Name = ""
        self.Wallet = 0
        self.imageURL = ""
        self.Email = ""
        self.Phone = ""
    }
}
