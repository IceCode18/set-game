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
    lazy var usableCards = startCards
    var symbols = ["▲","●","■"]
    var colors = [#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)]
    var numberOfPairsOfCards : Int {
        return (cardButtons.count+1)/2
    }
    
    lazy var game = Game(fieldCards: numberOfPairsOfCards, startingCards: startCards, numOfStyles: numStyles)
    
    @IBOutlet weak var playerScore: UILabel!
    
    @IBOutlet weak var aiScore: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    
    
    
    
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
    
    
    @IBAction func dealCard(_ sender: UIButton) {
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            updateViewFromModel()
        }
    
    private func updateViewFromModel(){
        //flipCountLabel.text = "Flips: \(game.flips)"
        //score.text = "Score: \(game.gameScore)"
        for index in 0...usableCards-1{
            let button = cardButtons[index]
            let card = game.field[index]
            if card.isSelected{
                //button.setTitle(emoji(for: card), for: UIControl.State.normal)
                print("Card selected")
                button.layer.borderWidth = 4.0
                button.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }else{
                button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            //Card Attributes
            let sym = symbols[card.attributeCodes[symbol]-1]
            let symCount = card.attributeCodes[number]
            let clr = colors[card.attributeCodes[color]-1]
            button.setTitle(String(repeating: sym, count: symCount), for: UIControl.State.normal)
            button.setTitleColor(clr, for: .normal)
        }
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
