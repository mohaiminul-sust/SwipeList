//
//  ToDoItem.swift
//  SwipeList
//
//  Created by ANDROMEDA on 7/14/16.
//  Copyright © 2016 infancyit. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {
   
    var text: String
    var completed: Bool
    
    init(text: String) {
        self.text = text
        self.completed = false
    }
}
