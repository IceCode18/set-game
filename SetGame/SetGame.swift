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
    
    //Test Cases
    enum matchType {
        case allSame
        case allDifferent
        case noMatch
    }
    
    func testMatch(selectedCards: [Int]) -> Bool{
        var match = 0
        
        for codeIndex in 0...(numTests-1){
            var testPassed = matchType.noMatch
            var counter = 0
            var m = 0
            for i in selectedCards{
                let code = field[i].attributeCodes[codeIndex]
                print("M: \(m) Code: \(code)")
                (m == code) ? (counter += 1) : (counter -= 1)
                m = code
                print("Counter: \(counter)")
                
            }
            if(counter == maxSelect-2){
                testPassed = .allSame
            }
            if(counter == 0-maxSelect){
                testPassed = .allDifferent
            }
            switch testPassed {
            case .allSame:
                match += 1
                print("The types are all the same!")
            case .allDifferent:
                match += 1
                print("The types are all different!")
            default:
                print("No Match")
                break
            }
        }
        if(match == numTests){return true}
        return false
    }
    
    func chooseCard(at index: Int){
        if !(field[index].isSelected){
            field[index].isSelected = true
            selection.append(index)
            print("Card \(index) is stored in Selection. Card ID: \(field[index].id).")
            if (selection.count == maxSelect){
                if testMatch(selectedCards: selection){
                    for i in selection{
                        field[i].isMatched = true
                        print("Card No.\(field[i].id) is matched.")
                    }
                    print("Score!")
                }else{
                    print("Score Reduction!")
                }
            }
            if(selection.count > maxSelect){
                let fourthSelect = field[selection.removeLast()]
                cleanSelection()
                selection.append(field.firstIndex(of: fourthSelect)!)
                print("Card \(index) is stored in Selection. Card ID: \(field[selection.head].id).")
            }
        }
    }
    
    func cleanSelection(){
        selection.sort()
        print("Selection Count: \(selection.count)")
        for _ in selection.indices{
            let index = selection.removeLast()
            field[index].isSelected = false
            if(field[index].isMatched){
                print("Removed card at position \(index) from the field. Card ID: \(field[index].id).")
                field.remove(at: index)
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
        //deck.shuffle()
        for _ in 0...startingCards{
            field.append(deck.removeLast())
            print(deck.count)
        }
        print(field[0])
        print(field[1])
        print(field[2])
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
