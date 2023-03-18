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
    var maxFieldCards: Int
    var playerScore = 0
    var aiScore = 0
    
    //Constants
    final let maxSelect = 3
    final let numTests = 4
    final let cardsPerDeal = 3
    
    //Test Cases
    enum matchType {
        case allSame
        case allDifferent
        case noMatch
    }
    
    init(fieldCards: Int, startingCards: Int, numOfStyles:Int){
        maxFieldCards = fieldCards
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
        //deck.shuffle()
        for _ in 1...startingCards{
            field.append(deck.removeLast())
            print(deck.count)
        }
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
        if(field[index].isSelected && selection.count != 3){
            removeFromSelection(index: index)
        }
        else if !(field[index].isSelected){
            field[index].isSelected = true
            selection.append(index)
            print("Card \(index) is stored in Selection. Card ID: \(field[index].id).")
            if (selection.count == maxSelect){
                if testMatch(selectedCards: selection){
                    for i in selection{
                        field[i].isMatched = true
                        print("Card No.\(field[i].id) is matched.")
                    }
                    playerScore += 5
                    print("Score!")
                }else{
                    playerScore -= 3
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
    
    func dealCards(){
        if(selection.count == 3){
            if(testMatch(selectedCards: selection)){
                cleanSelection()
            }else{
                addCards()
            }
        }else{
            addCards()
        }
        
        for c in selection{
            field[c].isSelected = false
        }
        selection.removeAll()
        print("Dealt Cards. Selection now has: \(selection.count)")
    }
    
    func addCards(){
        for _ in 1...cardsPerDeal{
            if(field.count != maxFieldCards && !deck.isEmpty){
                field.append(deck.removeLast())
                print("Added Card ID: \(field[field.count-1].id) ")
            }
        }
    }
    func removeFromSelection(index: Int){
        if(field[index].isSelected){
            field[index].isSelected = false
            selection.remove(at: selection.firstIndex(of: index)!)
        }
    }
    func cleanSelection(){
        selection.sort()
        print("Selection Count: \(selection.count)")
        for _ in selection.indices{
            let index = selection.removeLast()
            field[index].isSelected = false
            if(field[index].isMatched){
                if(!deck.isEmpty){
                    field[index] = deck.removeLast()
                    print("Replaced field card position \(index) with card No. \(field[index].id)")
                }else{
                    print("Removed card at position \(index) from the field. Card ID: \(field[index].id).")
                    field.remove(at: index)
                }
            }
        }
    }
    
    func findMatch(byPlayer: Bool) -> Bool{
        //Search for the first occurence of a match
        for i in field.indices{
            for j in field.indices{
                for k in field.indices{
                    if( (i != j) && (i != k) && (j != k) ){
                        if(testMatch(selectedCards: [i,j,k])){
                            cleanSelection()
                            field[i].isMatched = true
                            field[k].isMatched = true
                            field[j].isMatched = true
                            
                            print("Card No.\(field[i].id) is matched.")
                            print("Card No.\(field[j].id) is matched.")
                            print("Card No.\(field[k].id) is matched.")
                            
                            selection = [i,j,k]
                            cleanSelection()
                            if(byPlayer){
                                playerScore += 5
                                print("Score!")
                            }
                            else{
                                aiScore += 5
                                print("AI Scores!")
                            }
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    
    func createCard(number: Int,color: Int,shade: Int,symbol: Int) -> Card{
        return Card(cNumber: number,cColor: color,cShade: shade,cSymbol: symbol)
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
