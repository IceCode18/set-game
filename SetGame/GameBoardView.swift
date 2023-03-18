//
//  GameBoardView.swift
//  SetGame
//
//  Created by Kaiser19 on 6/3/19.
//  Copyright © 2019 Kaiser19. All rights reserved.
//

import UIKit

class GameBoardView: UIView {

    /*private(set) */var cardViews = [CardView](){didSet { setNeedsDisplay() }}
    private var grid = Grid(layout: .aspectRatio((5.0/3.0)))
    
    func add(card: Card, index: Int){
        let cardView = CardView(frame: CGRect.zero)
        cardView.setAttributes(card: card, newIndex: index)
        cardViews.append(cardView)
        addSubview(cardView)
        setNeedsLayout()
    }
    
    
    func removeCardsAT(index: Int){
        cardViews[index].removeFromSuperview()
        cardViews.remove(at: index)
        //cardViews[index].isHidden = true
    }
    
    func resetCards(){
        for card in cardViews{
            card.removeFromSuperview()
        }
        cardViews.removeAll()
        //print("Card View Count: \(cardViews.count)")
    }
    
    func redrawCardWith(card: Card, index: Int){
        cardViews[index].clearsContextBeforeDrawing = true
        cardViews[index].setAttributes(card: card, newIndex: index)
    }
    
    override func layoutSubviews() {
        grid.cellCount = cardViews.count
        grid.frame = bounds
        for index in cardViews.indices {
            if let rect = grid[index] {
                cardViews[index].frame = rect.insetBy(dx: 5.0, dy: 5.0)
            }
            
        }
    }

}
