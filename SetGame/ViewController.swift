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
    final let numStyles = 4
    
    //Variables
    lazy var usableCards = startCards
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
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            if card.isSelected{
                //button.setTitle(emoji(for: card), for: UIControl.State.normal)
                print("Card selected")
                button.layer.borderWidth = 3.0
                button.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            }else{
                button.setTitle("X", for: UIControl.State.normal)
                button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                //button.backgroundColor =  card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : cardBackgroundChoice
                
            }
            
        }
    }
    
}

