//
//  CardView.swift
//  SetGame
//
//  Created by Kaiser19 on 6/2/19.
//  Copyright © 2019 Kaiser19. All rights reserved.
//

import UIKit

class CardView: UIView {

    // MARK: Card properties
    var number: Int = 3 { didSet { setNeedsDisplay() } }
    var color: Int? { didSet { setNeedsDisplay() } }
    var shade: Int? { didSet { setNeedsDisplay() } }
    var symbol: Int? { didSet { setNeedsDisplay() } }
    
    //Constants
    final let widthScale: CGFloat = 0.90
    final let heightScale: CGFloat = 0.80
   
    //Scalings
    private var drawableRect: CGRect {
        let drawableWidth = bounds.size.width * widthScale
        let drawableHeight = bounds.size.height * heightScale
        
        return CGRect(x: bounds.size.width,
                      y: bounds.size.height,
                      width: drawableWidth,
                      height: drawableHeight)
    }
    
    private var figXmargin: CGFloat {
        return (bounds.size.width - drawableRect.width)/2
    }
    
    private var figYmargin: CGFloat {
        return (bounds.size.height - drawableRect.height)/2
    }
    
    private var figWidth: CGFloat {
        return (drawableRect.width / 3) - (figXmargin * 2)
    }
    
    private var figHeight: CGFloat {
        return drawableRect.height
    }
    
    private var cardCenter: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    //Main Drawing Part
    override func draw(_ rect: CGRect) {
        let color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        let path = UIBezierPath()
        
        for n in 0...number-1 {
            let margin: CGFloat
            if n == 0 {
                margin = figXmargin
            }else{
                margin = figXmargin * 2
            }
            let origin:CGFloat = (figXmargin * 2) + ((figWidth + margin) * CGFloat(n))
            squiggles(bezPath: path, count: CGFloat(number), originX: origin)
            print(origin)
            
        }
        
        path.lineCapStyle = .round
        path.lineWidth = 3.0
        color.setStroke()
        path.stroke()
        
        
    }
    
    func squiggles(bezPath: UIBezierPath, count: CGFloat, originX: CGFloat){
        let originX = originX
        let originY = figYmargin
        let curveXOffset = figWidth * 0.75
        
        bezPath.move(to: CGPoint(x: originX, y: originY))
        
        bezPath.addCurve(to: CGPoint(x: originX, y: originY + figHeight),
                      controlPoint1: CGPoint(x: originX + curveXOffset, y: originY + figHeight / 3),
                      controlPoint2: CGPoint(x: originX - curveXOffset, y: originY + (figHeight / 3) * 2))
        
        bezPath.addLine(to: CGPoint(x: originX + figWidth, y: originY + figHeight))
        
        bezPath.addCurve(to: CGPoint(x: originX + figWidth, y: originY),
                      controlPoint1: CGPoint(x: originX + figWidth - curveXOffset, y: originY + (figHeight / 3) * 2),
                      controlPoint2: CGPoint(x: originX + figWidth + curveXOffset, y: originY + figHeight / 3))
        
        bezPath.addLine(to: CGPoint(x: originX, y: originY))
        
        
    }
    
    func designateCard(card: Card){
        number = card.number
        color = card.color
        shade = card.shade
        symbol = card.symbol
    }

   
}
