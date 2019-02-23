//
//  Parsing.swift
//  Tempo
//
//  Created by bharath on 2019/02/22.
//  Copyright © 2019 shitian.ni. All rights reserved.
//

import Foundation

func parseCar(json: Data) ->Car {
    var car = Car()
    let decoder = JSONDecoder()
    do {
        car = try decoder.decode(Car.self, from: json)
        return car
        
    } catch {
        print("error trying to convert data to JSON")
        print(error)
        return car
    }
    
}

func parseBooking(json: Data) -> Booking {
    var booking = Booking()
    let decoder = JSONDecoder()
    do {
        booking = try decoder.decode(Booking.self, from: json)
        return booking
        
    } catch {
        print("error trying to convert data to JSON")
        print(error)
        return booking
    }
    
}

func parseDashboard(with data: Data) -> UserDashboard {
    var userDash = UserDashboard()
    
    let decoder = JSONDecoder()
    do{
        userDash = try decoder.decode(UserDashboard.self, from: data)
        return userDash
    } catch {
        print("error trying to convert data to JSON")
        print(error)
        return userDash
    }
}


