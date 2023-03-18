//
//  GameBoardView.swift
//  SetGame
//
//  Created by Kaiser19 on 6/3/19.
//  Copyright © 2019 Kaiser19. All rights reserved.
//

import UIKit

class GameBoardView: UIView {

    private(set) var cardViews = [CardView]()
    
    var grid = Grid(layout: .aspectRatio((5.0/3.0)))
    
    func add(cardView: CardView) {
        cardViews.append(cardView)
        addSubview(cardView)
        setNeedsLayout()
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
