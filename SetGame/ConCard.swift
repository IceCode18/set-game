//
//  Card.swift
//  Project1
//
//  Created by Jaykant Tiano on 5/13/19.
//  Copyright © 2019 Jaykant Tiano. All rights reserved.
//

import Foundation

struct ConCard
{
    var isFaceUp = false
    var isMatched = false
    var hasBeenMismatched = false
    var identifier: Int
    
    private static var indentifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int{
        indentifierFactory += 1
        return indentifierFactory
    }
    
    init(){
        self.identifier = ConCard.getUniqueIdentifier()
    }
}

