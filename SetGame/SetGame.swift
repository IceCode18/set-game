//
//  SetGame.swift
//  SetGame
//
//  Created by Kaiser19 on 5/18/19.
//  Copyright © 2019 Kaiser19. All rights reserved.
//

import Foundation

class Game{
    
    //Buckets
    var deck = [Card]()
    var field = [Card]()
    var selection = [Int]()
    
    //Constants
    final let maxSelect = 3
    final let numTests = 4
    
    enum matchType {
        case allSame
        case allDifferent
        case noMatch
    }
    
    func testMatch(cards: [Int]) -> Bool{
        var match = false
        
        for codeIndex in 0...(numTests-1){
            var testPassed = matchType.noMatch
            var counter = 0
            var m = 0
            for i in cards{
                let code = field[i].attributeCodes[codeIndex]
                (m == code) ? (counter += 1) : (counter -= 1)
                m = code
            }
            if(counter == maxSelect-1){
                testPassed = .allSame
            }
            if(counter == (0-(maxSelect-1))){
                testPassed = .allDifferent
            }
            print(counter)
            switch testPassed {
            case .allSame:
                match = true
                print("The types are all the same!")
            case .allDifferent:
                match = true
                print("The types are all different!")
            default:
                match = false
                print("No Match")
            }
        }
        return match
    }
    
    func chooseCard(at index: Int){
        if !(field[index].isSelected){
            field[index].isSelected = true
            selection.append(index)
            print("Card \(index) is stored in Selection. Card ID: \(field[index].id).")
            if (selection.count == maxSelect){
                if testMatch(cards: selection){
                    for i in selection{
                        field[i].isMatched = true
                    }
                    print("Score!")
                }else{
                    print("Score Reduction!")
                }
            }
            if(selection.count > maxSelect){
                var orderedSelection = [Int]()
                
                while (selection.count != 1){
                    var maxID = -1
                    for sel in selection{
                        if(field[sel].id > maxID){
                            //maxID
                        }
                        
                    }
                }
                for _ in 1...maxSelect{
                    let position = selection.remove(at: selection.head)
                    print("Removed card at position \(position) from the field. Card ID: \(field[position].id).")
                    field.remove(at: position)
                    
                }
                
            }
        }
    }
    
    init(numOfStyles:Int, startingCards: Int){
        for n in 1...numOfStyles{
            for c in 1...numOfStyles{
                for sh in 1...numOfStyles{
                    for sym in 1...numOfStyles{
                        let card = createCard(number: n, color: c, shade: sh, symbol: sym)
                        deck += [card]
                        print(card)                    }
                }
            }
        }
        deck.shuffle()
        for _ in 0...startingCards{
            field.append(deck.remove(at: deck.tail))
            print(deck.count)
        }
        chooseCard(at: 0)
        chooseCard(at: 1)
        chooseCard(at: 2)
        chooseCard(at: 3)
    }
    
    func createCard(number: Int,color: Int,shade: Int,symbol: Int) -> Card{
        return Card(cNumber: number,cColor: color,cShade: shade,cSymbol: symbol)
    }
    
    
}


extension Int{
    var arc4random: Int{
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else{
            return 0
        }
    }
}

extension Array{
    var tail: Int{
        return self.endIndex-1
    }
    var head: Int{
        return 0
    }
}
