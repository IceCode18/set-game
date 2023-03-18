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
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var bounce = BouncingAnimation(in: animator)
    
    @IBOutlet weak var gameBoard: GameBoardView!
    
    @IBOutlet weak var playerScore: UILabel!
    
    @IBOutlet weak var aiFace: UILabel!
    
    @IBOutlet weak var aiScore: UILabel!
    
    @IBOutlet weak var dealButton: UIButton!
    
    @IBOutlet weak var discardPile: UIButton!
    
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
        if (recognizer.view as? GameBoardView) != nil && recognizer.state == .ended {shuffle()} else { return }
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
        var matchFound = false
        //print("CardListCount: \(gameBoard.cardViews.count)")
        playerScore.text = "Player Score: \(game.playerScore)"
        //aiScore.text = "AI Score: \(game.aiScore)"
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
                    
                    if card.isMatched{
                        pseudoButton.layer.borderWidth = 4.0
                        pseudoButton.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                        pseudoButton.alpha = 0
                        matchFound = true
                    }
//                    else{
//                        gameBoard.redrawCardWith(card: card, index: index)
//                    }
                }
            }
        }
        if(matchFound){
            let newCardViews = gameBoard.cardViews.filter{ $0.alpha ==  0  }
            bounceEffect(cards: newCardViews)
            dealCards()
        }

        
        
    }
    
    func bounceEffect(cards: [CardView]){
        var counter = 0
        for pseudoButton in cards{
            view.addSubview(pseudoButton)
            pseudoButton.layer.zPosition = 99.0
            pseudoButton.alpha = 1
            self.bounce.addItem(pseudoButton)
//            UIView.transition(
//                with: pseudoButton,
//                duration: 0.6,
//                options: [.transitionFlipFromLeft],
//                animations: {
//                    pseudoButton.layer.zPosition = 99.0
//                    pseudoButton.alpha = 1
//                    self.bounce.addItem(pseudoButton)
//                            }
//            )
        }
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            counter += 1
            if counter == 4 {
                for pseudoButton in cards{
                    self.bounce.removeItem(pseudoButton)
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 1.0,
                        delay: 0,
                        options: [.curveEaseIn],
                        animations: {
                            print("EXEC")
                            pseudoButton.frame = self.gameBoard.deckFrame
                            
                        },
                        completion: {
                            position in
                            self.gameBoard.removeCardView(card: pseudoButton)
                        }
                    )
                }
                timer.invalidate()
            }
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
        let set = gameBoard.cardViews
        gameBoard.shuffleEffect(cards: set)
    }
    
    func resetGame(){
        game = Game(fieldCards: maxFieldCards, startingCards: startCards, numOfStyles: numStyles)
        gameBoard.deckFrame = CGRect(x: dealButton.frame.minX, y: gameBoard.frame.maxY-dealButton.frame.height, width: dealButton.frame.width, height: dealButton.frame.height)
        print(gameBoard.deckFrame)
        
        gameBoard.resetCards()
//        for card in game.field{
//            gameBoard.add(card: card, index: game.field.firstIndex(of: card)!)
//        }
//        for views in gameBoard.cardViews{
//            addGestureRecognizersToCard(views)
//        }
        while gameBoard.cardViews.count < startCards{
            dealCards()
            game.playerScore = 0
        }
        //gameBoard.layoutSubviews()
        
        
        hintButton.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        dealButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        hintButton.isEnabled = true
        dealButton.isEnabled = true
        //aiFace.text = "🤔"
        updateViewFromModel()
    }
    
}
