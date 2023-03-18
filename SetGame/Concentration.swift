//
//  Concentration.swift
//  Project1
//
//  Created by Jaykant Tiano on 5/13/19.
//  Copyright © 2019 Jaykant Tiano. All rights reserved.
//

import Foundation

class Concentration
{
    private(set) var cards = [ConCard]()
    
    private(set) var flips =  0
    
    private(set) var gameScore = 0
    
    private var indexOfOnlyFaceUpCard: Int?{
        get{
            var foundIndex: Int?
            for index in cards.indices{
                if cards[index].isFaceUp{
                    if foundIndex == nil{
                        foundIndex = index
                    }else{
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set{
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    private var previous = CFAbsoluteTimeGetCurrent()
    
    //?
    func chooseCard(at index: Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched && !cards[index].isFaceUp{
            let current = CFAbsoluteTimeGetCurrent()
            if let matchIndex = indexOfOnlyFaceUpCard, matchIndex != index{
                if cards[matchIndex].identifier == cards[index].identifier{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    var bonus = Int((8-(current-previous)).rounded())
                    if(bonus<0){bonus=0}
                    gameScore += (2 + bonus)
                    previous = current
                }
                else {
                    if cards[matchIndex].hasBeenMismatched{gameScore -= 1}
                    if cards[index].hasBeenMismatched{gameScore -= 1}
                }
                cards[index].hasBeenMismatched = true
                cards[matchIndex].hasBeenMismatched = true
                cards[index].isFaceUp = true
            } else{
                indexOfOnlyFaceUpCard = index
            }
            
            flips += 1
        }
    }
    
    
    init(numberOfPairsOfCards: Int){
        assert(numberOfPairsOfCards>0, "Concentration.init(at: \(numberOfPairsOfCards)): must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards
        {
            let card = ConCard()
            cards += [card, card]
        }
        
        // TODO: Shuffle Cards?
        cards.shuffle()
    }
}
