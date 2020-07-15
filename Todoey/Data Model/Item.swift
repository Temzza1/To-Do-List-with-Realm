//
//  Item.swift
//  Todoey
//
//  Created by Artem Mazur on 09.07.2020.
//  Copyright © 2020 Artem Mazur. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class Item: Object {
    dynamic var title: String = ""
    dynamic var done: Bool = false
    dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
