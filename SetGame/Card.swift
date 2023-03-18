//
//  Card.swift
//  SetGame
//
//  Created by Kaiser19 on 5/18/19.
//  Copyright © 2019 Kaiser19. All rights reserved.
//

import Foundation

struct Card:CustomStringConvertible, Comparable {
    static func < (lhs: Card, rhs: Card) -> Bool {
       return lhs.id < rhs.id
    }
    
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    var description: String {return "\(number),\(color),\(shade),\(symbol)"}
    var isMatched = false
    var isSelected = false
    var id: Int
    var attributeCodes = [Int]()
    
    var number: Int
    var color: Int
    var shade: Int
    var symbol: Int
    
    
    private static var currentTotal = 0
    
    private static func getID() -> Int{
        currentTotal += 1
        return currentTotal
    }
    
    init(cNumber: Int, cColor: Int, cShade: Int, cSymbol: Int ) {
        self.id = Card.getID()
        self.number = cNumber
        self.color = cColor
        self.shade = cShade
        self.symbol = cSymbol
        self.attributeCodes = [cNumber,cColor,cShade,cSymbol]
    }
}

