//
//  Category.swift
//  Todoey
//
//  Created by Artem Mazur on 09.07.2020.
//  Copyright © 2020 Artem Mazur. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class Category: Object {
    dynamic var name: String = ""
    dynamic var color: String = ""
    
    let items = List<Item>()
    
    
}
