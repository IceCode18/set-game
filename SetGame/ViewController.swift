//
//  ViewController.swift
//  SetGame
//
//  Created by Kaiser19 on 5/18/19.
//  Copyright © 2019 Kaiser19. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //private var game = Game(numOfStyles: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var game = Game(fieldCards: 32, startingCards: 12, numOfStyles: 4)
    }
    
    @IBOutlet weak var playerScore: UILabel!
    
    @IBOutlet weak var aiScore: UILabel!
    
    @IBAction func touchCard(_ sender: UIButton) {
        
    }
    
    
    @IBAction func dealCard(_ sender: UIButton) {
    }
    
    
}

