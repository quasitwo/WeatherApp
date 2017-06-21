//
//  City.swift
//  WeatherApp
//
//  Created by Sierra on 07/06/2017.
//  Copyright © 2017 Sierra. All rights reserved.
//

import Foundation


class City: NSObject, NSCoding {
    let name: String
    let id: Int
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
    
    convenience init(_ name: String, id: Int) {
        self.init(name: name, id: id)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let id = aDecoder.decodeInteger(forKey: "id")
        self.init(name: name, id: id)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(id, forKey: "id")
    }
}
