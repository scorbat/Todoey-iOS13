//
//  Category.swift
//  Todoey
//
//  Created by admin on 5/26/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    
    let items = List<Item>()
}
