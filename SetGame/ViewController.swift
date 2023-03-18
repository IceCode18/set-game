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
    final let startCards = 12
    final let numStyles = 3
    final let maxFieldCards = 81
    
    
    //Variables
    lazy var game: Game = Game(fieldCards: maxFieldCards, startingCards: startCards, numOfStyles: numStyles)
    var timer: Timer?
    var aiTurn = 0
    
    @IBOutlet weak var gameBoard: GameBoardView!
    
    @IBOutlet weak var playerScore: UILabel!
    
    @IBOutlet weak var aiFace: UILabel!
    
    @IBOutlet weak var aiScore: UILabel!
    
    @IBOutlet weak var dealButton: UIButton!
    
    @IBOutlet weak var hintButton: UIButton!
    
    @IBAction func hint(_ sender: UIButton) {
        let matchingCards = game.findMatch()
        if(!(matchingCards.isEmpty)){
            game.hintActivated(byPlayer: true, matchingCards: matchingCards)
            print("Match Found")
        }
        updateViewFromModel()
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        resetGame()
    }
    
    @IBAction func dealCards(_ sender: UIButton) {
        game.dealCards()
        for i in 1...game.cardsPerDeal{
            if (game.deck.count != 0){
                let index = game.field.count - i
                let card = game.field[index]
                gameBoard.add(card: card)
            }
        }
        updateViewFromModel()
    }
    
    
    @IBAction func touchCard(_ sender: CardView) {
        if let cardNumber = gameBoard.cardViews.firstIndex(of: sender){
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
        resetGame()
        //        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] (timer) in
        //            self?.aiTurn += 2
        //            if(self!.aiTurn == 8){
        //                self?.game.hintActivated(byPlayer: false, matchingCards: self!.game.findMatch())
        //                self?.aiTurn = 0
        //                self?.aiFace.text = "😂"
        //            }else if(self!.aiTurn == 6){
        //                self?.aiFace.text = "😏"
        //            }else if(self!.aiTurn == 4){
        //                self?.aiFace.text = "😗"
        //            }else if(self!.aiTurn == 2){
        //                self?.aiFace.text = "🤔"
        //            }
        //            self?.updateViewFromModel()
        //        }
    }

    
    private func updateViewFromModel(){
        print("CardListCount: \(gameBoard.cardViews.count)")
        playerScore.text = "Player Score: \(game.playerScore)"
        aiScore.text = "AI Score: \(game.aiScore)"
        if(game.deck.isEmpty){
            dealButton.backgroundColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
            dealButton.isEnabled = false
        }
        if(game.findMatch().isEmpty){
            hintButton.backgroundColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
            hintButton.isEnabled = false
        }else{
            hintButton.isEnabled = true
            hintButton.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        }
        for index in game.field.indices{
            let card = game.field[index]
            if (index < gameBoard.cardViews.count){
                let pseudoButton = gameBoard.cardViews[index]
                //print("Field: \(index) Field Count: \(game.field.count)")
                
                if card.isSelected{
                    print("Card selected")
                    pseudoButton.layer.borderWidth = 4.0
                    pseudoButton.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                }else{
                    pseudoButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
                
                if card.isMatched {
                    pseudoButton.layer.borderWidth = 4.0
                    pseudoButton.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                }
                
                gameBoard.redrawCardWith(card: card, index: index)
                
                if(game.deck.isEmpty && card.isMatched){
                    gameBoard.removeCardsAT(index: index)
                }
                
            }else{
                gameBoard.add(card: card)
            }
         
        }
        //score.text = "Score: \(game.gameScore)"
//        for index in gameBoard.cardViews.indices{
//            let pseudoButton = gameBoard.cardViews[index]
//            if (game.field.indices.contains(index)){
//                //print("Field: \(index) Field Count: \(game.field.count)")
//                let card = game.field[index]
//                if card.isSelected{
//                    print("Card selected")
//                    pseudoButton.layer.borderWidth = 4.0
//                    pseudoButton.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
//                }else{
//                    pseudoButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//                }
//                if pseudoButton.isHidden { pseudoButton.isHidden = false}
//                if card.isMatched {
//                    pseudoButton.layer.borderWidth = 4.0
//                    pseudoButton.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
//                }
//
//                pseudoButton.isHidden = false
//                if(game.deck.isEmpty && card.isMatched){
//                    gameBoard.removeCardsAT(index: index)
//                }
//            }
//            else{
//                gameBoard.removeCardsAT(index: index)
//            }
//        }
    }
    
    func resetGame(){
        game = Game(fieldCards: maxFieldCards, startingCards: startCards, numOfStyles: numStyles)
        gameBoard.resetCards()
        for card in game.field{
            gameBoard.add(card: card)
        }
        hintButton.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        dealButton.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        hintButton.isEnabled = true
        dealButton.isEnabled = true
        //aiFace.text = "🤔"
        updateViewFromModel()
    }
    
}
