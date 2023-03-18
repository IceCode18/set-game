//
//  ViewController.swift
//  SetGame
//
//  Created by Kaiser19 on 5/18/19.
//  Copyright © 2019 Kaiser19. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Constants
    final let startCards = 16
    final let numStyles = 3
    final let number = 0
    final let color = 1
    final let shade = 2
    final let symbol = 3
    
    
    //Variables
    var symbols = ["▲","●","■"]
    var colors = [#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)]
    var numberOfPairsOfCards : Int {
        return cardButtons.count
    }
    
    lazy var game = Game(fieldCards: numberOfPairsOfCards, startingCards: startCards, numOfStyles: numStyles)
    
    @IBOutlet weak var playerScore: UILabel!
    
    @IBOutlet weak var aiScore: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func hint(_ sender: UIButton) {
        if(game.findMatch(byPlayer: true)){
            print("Match Found")
        }else{
            print("No matches available")
        }
        updateViewFromModel()
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        resetGame()
    }
    
    @IBAction func dealCards(_ sender: UIButton) {
        game.dealCards()
        updateViewFromModel()
    }
    
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender){
            print(cardNumber)
            game.chooseCard(at: cardNumber)
        }
        else{
            print("Choosen card is still unavailable.")
        }
        updateViewFromModel()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    private func updateViewFromModel(){
        playerScore.text = "Player Score: \(game.playerScore)"
        //score.text = "Score: \(game.gameScore)"
        for index in game.field.indices{
            let button = cardButtons[index]
            print("Field: \(index) Field Count: \(game.field.count)")
            let card = game.field[index]
            if card.isSelected{
                //button.setTitle(emoji(for: card), for: UIControl.State.normal)
                print("Card selected")
                button.layer.borderWidth = 4.0
                button.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }else{
                button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            if button.isHidden { button.isHidden = false}
            if card.isMatched {
                button.layer.borderWidth = 4.0
                button.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            }
            //---Card Attributes---/
            //Number
            let symCount = card.attributeCodes[number]
            //Color
            let clr = colors[card.attributeCodes[color]-1]
            //Symbol
            let cString = String(repeating: symbols[card.attributeCodes[symbol]-1], count: symCount)
            //shade
            var cAlpha:Float
            var cStroke: Float
            
            switch(card.attributeCodes[shade]){
                case 2:
                    cAlpha = 0.5
                    cStroke = -11
                case 3:
                    cAlpha = 1
                    cStroke = 10
                default:
                    cAlpha = 1.0
                    cStroke = 0
            }
            
            //Apply Attributes
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: clr.withAlphaComponent(CGFloat(cAlpha)),
                .strokeWidth: cStroke
            ]
            let sym = NSAttributedString(string: cString, attributes: attributes)
            
            
            button.setAttributedTitle(sym, for: UIControl.State.normal)
            button.isHidden = false
        }
    }
    
    func resetGame(){
        game = Game(fieldCards: numberOfPairsOfCards, startingCards: startCards, numOfStyles: numStyles)
        for b in startCards...numberOfPairsOfCards-1{
            cardButtons[b].isHidden = true
        }
        updateViewFromModel()
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
