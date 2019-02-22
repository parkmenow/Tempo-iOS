//
//  Car.swift
//  Tempo
//
//  Created by bharath on 2019/02/22.
//  Copyright © 2019 shitian.ni. All rights reserved.
//

import Foundation

struct Car : Codable {
    var ID: Int
    var NumberPlate: String
    var Status : String
    var CurrentNumOfTravellers : Int
    var Capacity : Int
    var CurrentLocation : String
    var CarType : String
    
    init() {
        self.ID = 0
        self.NumberPlate = ""
        self.Status = ""
        self.CurrentNumOfTravellers = 0
        self.Capacity = 0
        self.CurrentLocation = ""
        self.CarType = ""
    }
    
}
