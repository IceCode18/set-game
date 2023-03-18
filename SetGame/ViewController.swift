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
        dealCards()
    }
    
    //Gestures
    @objc func onCardTapGesture(_ recognizer: UITapGestureRecognizer) {
        guard let pseudoButton = recognizer.view as? CardView else { return }
        
        if let cardNumber = gameBoard.cardViews.firstIndex(of: pseudoButton){
            game.chooseCard(at: cardNumber)
        }
        else{
            print("Choosen card is still unavailable.")
        }
        updateViewFromModel()
    }
    
    @objc func onSwipeDown(_ recognizer: UITapGestureRecognizer) {
        if (recognizer.view as? GameBoardView) != nil {dealCards()} else { return }
        
    }
    
    @objc func onRotate(_ recognizer: UITapGestureRecognizer) {
        if (recognizer.view as? GameBoardView) != nil {shuffle()} else { return }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame()
        addGestureRecognizersToBoard(gameBoard)
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
        //print("CardListCount: \(gameBoard.cardViews.count)")
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
            if(index < game.field.count){
                let card = game.field[index]
                //print("Index \(index) CardViewCount: \(gameBoard.cardViews.count) FieldCount: \(game.field.count)")
                if (index < gameBoard.cardViews.count){
                    let pseudoButton = gameBoard.cardViews[index]
                    //print("Field: \(index) Field Count: \(game.field.count)")
                    
                    if card.isSelected{
                        //print("Card selected")
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
                    
                }
            }
        }
        while(gameBoard.cardViews.count > game.field.count){
            //print("called!!!!!!!!!!!!!!!!!!!!!!!!!!!! ")
            gameBoard.removeCardsAT(index: gameBoard.cardViews.count-1)
            //game.field.removeLast()
            //gameBoard.add(card: card, index: index)
        }
    }
    
    private func addGestureRecognizersToBoard(_ boardView: GameBoardView) {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeDown))
        swipe.direction = [.down]
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(onRotate))
        boardView.addGestureRecognizer(swipe)
        boardView.addGestureRecognizer(rotate)
    }
    
    private func addGestureRecognizersToCard(_ cardView: CardView) {
        cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCardTapGesture)))
    }
    
    func dealCards(){
        if (game.deck.count != 0){
            game.dealCards()
            for i in 1...game.cardsPerDeal{
                let index = game.field.count - i
                let card = game.field[index]
                gameBoard.add(card: card, index: index)
                addGestureRecognizersToCard(gameBoard.cardViews.last!)
                
            }
            
        }
        updateViewFromModel()
    }
    func shuffle(){
        game.shuffleField()
        updateViewFromModel()
    }
    
    func resetGame(){
        game = Game(fieldCards: maxFieldCards, startingCards: startCards, numOfStyles: numStyles)
        gameBoard.resetCards()
        for card in game.field{
            gameBoard.add(card: card, index: game.field.firstIndex(of: card)!)
        }
        for views in gameBoard.cardViews{
            addGestureRecognizersToCard(views)
        }
        hintButton.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        dealButton.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        hintButton.isEnabled = true
        dealButton.isEnabled = true
        //aiFace.text = "🤔"
        updateViewFromModel()
    }
    
}
