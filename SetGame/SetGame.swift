//
//  SetGame.swift
//  SetGame
//
//  Created by Kaiser19 on 5/18/19.
//  Copyright © 2019 Kaiser19. All rights reserved.
//

import Foundation

class Game{
    
    var deck = [Card]()
    var bin = [Card]()
    
    
    func testMatch(card: Int){
        
    }
    
    init(numOfStyles:Int){
        print("Alert")
        for n in 1...numOfStyles{
            for c in 1...numOfStyles{
                for sh in 1...numOfStyles{
                    for sym in 1...numOfStyles{
                        let card = createCard(number: n, color: c, shade: sh, symbol: sym)
                        deck += [card]
                        print(card)
                    }
                }
            }
            
        }
    }
    
    func createCard(number: Int,color: Int,shade: Int,symbol: Int) -> Card{
        return Card(cNumber: number,cColor: color,cShade: shade,cSymbol: symbol)
    }
    
    
}
