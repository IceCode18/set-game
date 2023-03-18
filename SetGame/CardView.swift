//
//  CardView.swift
//  SetGame
//
//  Created by Kaiser19 on 6/2/19.
//  Copyright © 2019 Kaiser19. All rights reserved.
//

import UIKit

class CardView: UIView {

    //Card properties
    @IBInspectable
    var codes: [Int] = [1, 1, 1, 1] { didSet { setNeedsDisplay() } }
    
    var number: Int { return codes[0] }//{ didSet { setNeedsDisplay() } }
    var color: Int { return codes[1] }//{ didSet { setNeedsDisplay() } }
    var shade: Int { return codes[2] }// { didSet { setNeedsDisplay() } }
    var symbol: Int { return codes[3] }
    
    var viewIndex: Int?
    var isFaceUp = false { didSet { setNeedsDisplay() } }

    
    //Constants
    final let widthScale: CGFloat = 0.90
    final let heightScale: CGFloat = 0.60
    final let lineThickness: CGFloat = 3.0
    
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
        if isFaceUp {
            var path = UIBezierPath()
            path.append(UIBezierPath(roundedRect: CGRect(x: figXmargin/2,
                                                         y: figYmargin/2,
                                                         width: bounds.size.width,
                                                         height: bounds.size.height),
                                     cornerRadius: 0))
            self.backgroundColor?.setFill()
            path.fill()
            path.stroke()
            path = UIBezierPath()
            
            for n in 0...number-1 {
                let margin: CGFloat
                if n == 0 {
                    margin = figXmargin
                }else{
                    margin = figXmargin * 2
                }
                
                let origin:CGFloat?
                
                switch(number){
                case 2:
                    origin = (cardCenter.x - (figWidth + (margin * 2))) + (CGFloat(n * 2) * (figWidth + margin/2))
                case 3:
                    origin = (figXmargin * 2) + ((figWidth + margin) * CGFloat(n))
                default:
                    origin = cardCenter.x - (figWidth/2)
                }
                
                
                
                switch(symbol){
                case 2:
                    diamonds(bezPath: path, count: CGFloat(number), originX: origin!)
                case 3:
                    squiggles(bezPath: path, count: CGFloat(number), originX: origin!)
                default:
                    ovals(bezPath: path, count: CGFloat(number), originX: origin!)
                }
                
            }
            
            path.lineCapStyle = .round
            path.lineWidth = lineThickness
            
            //pick a color
            let colorFill: UIColor?
            switch(color){
            case 2:
                colorFill = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            case 3:
                colorFill = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            default:
                colorFill = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            }
            
            switch(shade){
            case 2:
                colorFill!.setFill()
                path.fill()
            case 3:
                path.addClip()
                addStripes(bezPath: path)
                colorFill!.setStroke()
                
            default:
                colorFill!.setStroke()
            }
            
            path.stroke()
        }else{
            let path = UIBezierPath()
            path.append(UIBezierPath(roundedRect: CGRect(x: figXmargin/2,
                                                         y: figYmargin/2,
                                                         width: bounds.size.width,
                                                         height: bounds.size.height),
                                     cornerRadius: 0))
            let colorFill = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            colorFill.setFill()
            path.fill()
            path.stroke()
        }
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
    
    func diamonds(bezPath: UIBezierPath, count: CGFloat, originX: CGFloat){
        let halfHeight = figHeight/2
        let upperBound = cardCenter.y - halfHeight
        let bottomBound = cardCenter.y + halfHeight
        bezPath.move(to: CGPoint(x: originX + figWidth / 2, y: upperBound))
        bezPath.addLine(to: CGPoint(x: originX, y: cardCenter.y))
        bezPath.addLine(to: CGPoint(x: originX + figWidth / 2, y: bottomBound))
        bezPath.addLine(to: CGPoint(x: originX + figWidth, y: cardCenter.y))
        bezPath.addLine(to: CGPoint(x: originX + figWidth / 2, y: upperBound))
       
    }
    
    func ovals(bezPath: UIBezierPath, count: CGFloat, originX: CGFloat){
        bezPath.append(UIBezierPath(roundedRect: CGRect(x: originX,
                                                      y: figYmargin,
                                                      width: figWidth,
                                                      height: figHeight),
                                  cornerRadius: figWidth))
        
    }
    
    func addStripes(bezPath: UIBezierPath){
        let space:CGFloat = figHeight/6
        let rightBounds = drawableRect.width
        let lowerBounds = figHeight + figYmargin
        let originX = figXmargin
        var originY = figYmargin
        
        while(originY < lowerBounds){
            bezPath.move(to: CGPoint(x: originX, y:  originY))
            bezPath.addLine(to: CGPoint(x: rightBounds, y: originY))
            originY += space
        }
        
    }
    
    func setAttributes(card: Card, newIndex: Int){
        codes = card.attributeCodes
        viewIndex = newIndex
    }

    
    
    
    
   
}

