//
//  userDashboard.swift
//  Tempo
//
//  Created by bharath on 2019/02/23.
//  Copyright © 2019 shitian.ni. All rights reserved.
//

import Foundation

struct UserDashboard: Codable {
    var name : String
    var wallet: Int
    var imageURL : String
    
    
    init(){
        self.name = ""
        self.wallet = 0
        self.imageURL = ""
    }
}
