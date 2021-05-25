//
//  Item.swift
//  Todoey
//
//  Created by admin on 5/25/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    var task = ""
    var done = false
    
    init(_ task: String) {
        self.task = task
    }
}
