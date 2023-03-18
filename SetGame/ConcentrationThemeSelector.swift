//
//  ConcentrationThemeSelector.swift
//  Project1
//
//  Created by Kaiser19 on 6/12/19.
//  Copyright © 2019 Jaykant Tiano. All rights reserved.
//

import UIKit

class ConcentrationThemeSelector: UIViewController {

    @IBOutlet var themes: [UIButton]!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "PickTheme", let cvc = segue.destination as? ConcentrationViewController {
            if let themeButton = (sender as? UIButton), let gameTheme = themes.firstIndex(of: themeButton){
                cvc.themeCode = gameTheme
            }
        }
    }

}
