//
//  GameBoardView.swift
//  SetGame
//
//  Created by Kaiser19 on 6/3/19.
//  Copyright © 2019 Kaiser19. All rights reserved.
//

import UIKit

class GameBoardView: UIView {

    final let cardsPerDeal = 3
    final let fadeDuration = 0.5 //change back to 0.75
    
    var deckFrame = CGRect.zero{didSet { setNeedsDisplay() }}
    var cardViews = [CardView](){didSet { setNeedsDisplay() }}
    
    
    
    private var grid = Grid(layout: .aspectRatio((5.0/3.0)))
    
    func add(card: Card, index: Int){
        let cardView = CardView(frame: deckFrame)
        cardView.setAttributes(card: card, newIndex: index)
        cardView.alpha = 0
        cardViews.append(cardView)
        addSubview(cardView)
        setNeedsLayout()
    }
    
    func dealCard(cards: [CardView]){
        var newCards = cards
        if newCards.count != 0{
            let first = newCards.removeFirst()
            first.frame = deckFrame
            first.isFaceUp = false
            first.alpha = 1
            UIViewPropertyAnimator.runningPropertyAnimator(
                                    withDuration: fadeDuration,
                                    delay: 0,
                                    options: [.curveEaseIn],
                                    animations: {
                                        let gridIndex = self.cardViews.firstIndex(of: first)
                                        first.frame = self.grid[gridIndex!]!
                                    },	
                                    completion: { position in
                                                    if(!first.isFaceUp){
                                                        UIView.transition(
                                                            with: first,
                                                            duration: self.fadeDuration,
                                                            options: [.transitionFlipFromLeft],
                                                            animations: {
                                                                        first.isFaceUp = true
                                                                        }
                                                        )
                                                        self.dealCard(cards: newCards)
                                                    }
                                        
                                                }
            )
        }
    }
    
    func shuffleEffect(cards: [CardView]){
      for first in cards{
            first.frame = self.grid[cardViews.count/2]!
            first.isFaceUp = false
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: fadeDuration,
                delay: 0,
                options: [.curveEaseIn],
                animations: {
                    let gridIndex = self.cardViews.firstIndex(of: first)
                    first.frame = self.grid[gridIndex!]!
            },
                completion: { position in
                    if(!first.isFaceUp){
                        UIView.transition(
                            with: first,
                            duration: self.fadeDuration,
                            options: [.transitionFlipFromBottom],
                            animations: {
                                first.isFaceUp = true
                        }
                        )
                    }
                    
            }
            )
        }
    }
    
    func removeCardsAT(index: Int){
        cardViews[index].removeFromSuperview()
        cardViews.remove(at: index)
    }
    
    func removeCardView(card: CardView){
        if let index = cardViews.firstIndex(of: card){
            cardViews[index].removeFromSuperview()
            cardViews.remove(at: index)
        }
        
    }
    
    func resetCards(){
        for card in cardViews{
            card.removeFromSuperview()
        }
        cardViews.removeAll()
    }
    
    func redrawCardWith(card: Card, index: Int){
        cardViews[index].clearsContextBeforeDrawing = true
        cardViews[index].setAttributes(card: card, newIndex: index)
    }
    
    
    
    override func layoutSubviews() {
        grid.cellCount = cardViews.count
        grid.frame = bounds
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: fadeDuration,
            delay: 0,
            options: [.curveEaseIn],
            animations: {
                        for index in self.cardViews.indices {
                            if let rect = self.grid[index] {
                                self.cardViews[index].frame = rect.insetBy(dx: 5.0, dy: 5.0)
                            }
                        }
            },
            completion: {position in
                            let newCardViews = self.cardViews.filter{ $0.alpha ==  0  }
                            self.dealCard(cards: newCardViews)
                        }
        )
        
        
    }
    

    
}
