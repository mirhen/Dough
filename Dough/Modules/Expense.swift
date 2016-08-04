//
//  Expense.swift
//  Dough
//
//  Created by Miriam Hendler on 7/18/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit

class Expense: NSObject
{
    var amountOfMoney: Double!
    var expenseName: String!
    var itemTag: Int!
    var timeUnit: Int!
    var expenseImage: UIImage!
    
    init(amountOfMoney: Double, expenseName: String, itemTag: Int, timeUnit: Int, expenseImage: UIImage)
    {
        self.amountOfMoney = amountOfMoney
        self.expenseName = expenseName
        self.itemTag = itemTag
        self.timeUnit = timeUnit
        self.expenseImage = expenseImage
    }
    
//    required convenience init(coder aDecoder: NSCoder) {
//        let amountOfMoney = aDecoder.decodeDoubleForKey("amountOfMoney")
//        let expenseName = aDecoder.decodeObjectForKey("expenseName") as! String
//        let itemTag = aDecoder.decodeIntegerForKey("itemTag")
//        let timeUnit = aDecoder.decodeIntegerForKey("timeUnit")
//        let expenseImage = aDecoder.decodeObjectForKey("expenseImage") as! UIImage
//        self.init(amountOfMoney: amountOfMoney, expenseName: expenseName, itemTag: itemTag, timeUnit: timeUnit, expenseImage: expenseImage)
//    }
//    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeDouble(amountOfMoney, forKey: "amoutOfMoney")
//        aCoder.encodeObject(expenseName, forKey: "expenseName")
//        aCoder.encodeInteger(itemTag, forKey: "itemTag")
//        aCoder.encodeInteger(timeUnit, forKey: "timeUnit")
//        aCoder.encodeObject(expenseImage, forKey: "expenseImage")
//    }
}
