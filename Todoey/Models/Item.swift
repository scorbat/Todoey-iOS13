//
//  Item.swift
//  Todoey
//
//  Created by admin on 5/26/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
