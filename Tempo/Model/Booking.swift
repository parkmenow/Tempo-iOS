//
//  Booking.swift
//  Tempo
//
//  Created by bharath on 2019/02/22.
//  Copyright © 2019 shitian.ni. All rights reserved.
//

import Foundation

struct Booking : Codable {
    var ID: Int
    var RouteID: Int
    var TaxiID : Int
    var RiderID : Int
    var TravelDuration : Int
    var ETA : Int
    var Status : String
    
    
    init(){
        self.ID = 0
        self.RouteID = 0
        self.TaxiID = 0
        self.RiderID = 0
        self.TravelDuration = 0
        self.ETA = 0
        self.Status = ""
    }
}
