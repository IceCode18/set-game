//
//  ViewController.swift
//  Project1
//
//  Created by Jaykant Tiano on 5/13/19.
//  Copyright © 2019 Jaykant Tiano. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards : Int {
        return (cardButtons.count+1)/2
    }
    var emojiSets = [["🌆","🏙","🌃","🌄","🌉","🌇","🏞","🌁","🎑","🌌"],
                     ["😯","🤢","🤕","🤑","😴","🤤","😇","😂","😎","😩"],
                     ["✊🏻","🤜🏻","👋🏻","🤙🏻","🖐🏻","👊🏻","👍🏻","👎🏻","👌🏻","💪🏻"],
                     ["🤵🏻","👸🏻","🦸🏻‍♀️","🧟‍♀️","🧞‍♂️","🧜🏻‍♂️","👼🏻","🧛🏻‍♂️","🦹🏻‍♂️","🧞‍♀️"],
                     ["🦁","🐭","🐶","🐨","🐷","🐮","🐯","🐼","🐔","🐴"],
                     ["🍖","🍗","🍔","🍕","🥘","🌭","🍱","🍣","🍟","🥞"]]
    
    var emojiChoices = [""]
    var cardBackgrounds = [#colorLiteral(red: 0.5014055371, green: 0.801168859, blue: 0.8344416022, alpha: 1),#colorLiteral(red: 1, green: 0.9352530685, blue: 0, alpha: 1),#colorLiteral(red: 0.6161674905, green: 0.1265490591, blue: 0.1207803219, alpha: 0.8835616438),#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.8449201963, blue: 0.620580047, alpha: 1),#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)]
    var viewBackgrounds = [#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1),#colorLiteral(red: 0.2292556992, green: 0.02073439291, blue: 0.3487896697, alpha: 0.6267605634),#colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),#colorLiteral(red: 0.1234899883, green: 0.006919050485, blue: 0.3975452094, alpha: 0.7170109161)]
    var cardBackgroundChoice = #colorLiteral(red: 0.5014055371, green: 0.801168859, blue: 0.8344416022, alpha: 1)
    var viewBackgroundChoice = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    var themeCode = 0
    
    //instance variables are properties
    
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private weak var score: UILabel!
    
    @IBOutlet private weak var reset: UIButton!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    
    @IBAction private func gameReset(_ sender: UIButton) {
        resetGame()
    }
    
    
    // every argument has a name included in the parameter
    //each variable has two names: external & internal
    //optional is an enum with two values: set and not set
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }else{
            print("Chosen Card is not in Card Buttons")
        }
        
    }
    
    override func viewDidLoad() {
        setTheme()
        updateViewFromModel()
        
    }
    
    private func updateViewFromModel(){
        flipCountLabel.text = "Flips: \(game.flips)"
        score.text = "Score: \(game.gameScore)"
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }else{
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor =  card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : cardBackgroundChoice
                
            }
            
        }
    }
    
    private func resetGame(){
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        setTheme()
        updateViewFromModel()
    }
    
    private func setTheme(){
        //Pick theme
        let themeColor = cardBackgrounds[themeCode]
        emojiChoices = emojiSets[themeCode]
        cardBackgroundChoice = themeColor
        flipCountLabel.textColor = themeColor
        score.textColor = themeColor
        reset.backgroundColor = themeColor
        reset.titleLabel?.textColor = viewBackgrounds[themeCode]
        view.backgroundColor = viewBackgrounds[themeCode]
    }
    
    
    private var emoji = [Int:String]()
    
    func emoji(for card: ConCard) -> String {
        if emoji[card.identifier] == nil , emojiChoices.count > 0{
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        return emoji[card.identifier] ?? "?"
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
