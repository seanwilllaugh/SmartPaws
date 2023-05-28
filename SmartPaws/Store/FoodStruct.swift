//
//  FoodStruct.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/17/23.
//

import Foundation
import SwiftUI

struct Food: Identifiable{
    var id       : UUID
    var name     : String
    var cost     : Int
    var hapiness : Int
    var level    : Int
    var image    : String
}

func initializeFood() -> [Food]
{
    var foodList : [Food] = []
    
    let kibble  = Food(id: UUID(), name: "Basic Kibble", cost: 10, hapiness: 5 , level: 1, image: "kibble")
    foodList.append(kibble)
    
    let veggieKibble  = Food(id: UUID(), name: "Veggie Kibble", cost: 15, hapiness: 10, level: 5, image: "veggiekibble")
    foodList.append(veggieKibble)
    let chickenKibble = Food(id: UUID(), name: "Chicken Kibble", cost: 15, hapiness: 10, level: 5, image: "chickenkibble")
    foodList.append(chickenKibble)
    let steakKibble   = Food(id: UUID(), name: "Steak Kibble", cost: 15, hapiness: 10, level: 5, image: "steakkibble")
    foodList.append(steakKibble)
    
    let wetfood    = Food(id: UUID(), name: "Wet Dog Food", cost: 25, hapiness: 15, level: 10, image: "wetfood")
    foodList.append(wetfood)
    let vegetables = Food(id: UUID(), name: "Vegetables", cost: 25, hapiness: 15, level: 10, image: "vegetables")
    foodList.append(vegetables)

    let fish    = Food(id: UUID(), name: "Fish", cost: 50, hapiness: 30, level: 20, image: "fish")
    foodList.append(fish)
    let chicken = Food(id: UUID(), name: "Cooked Chicken", cost: 50, hapiness: 30, level: 20, image: "chicken")
    foodList.append(chicken)
    let steak   = Food(id: UUID(), name: "Cooked Steak", cost: 50, hapiness: 30, level: 20, image: "steak")
    foodList.append(steak)
    
    return foodList
}

