//
//  ConcentrationThemeSelector.swift
//  Project1
//
//  Created by Kaiser19 on 6/12/19.
//  Copyright © 2019 Jaykant Tiano. All rights reserved.
//

import UIKit

class ConcentrationThemeSelector: UIViewController , UISplitViewControllerDelegate{
    
    @IBOutlet var themes: [UIButton]!
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    @IBAction func chooseTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeButton = (sender as? UIButton), let gameTheme = themes.firstIndex(of: themeButton){
                cvc.themeCode = gameTheme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeButton = (sender as? UIButton), let gameTheme = themes.firstIndex(of: themeButton) {
                cvc.themeCode = gameTheme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "PickTheme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController
        ) -> Bool
    {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            return cvc.themeCode == nil
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "PickTheme", let cvc = segue.destination as? ConcentrationViewController {
            if let themeButton = (sender as? UIButton), let gameTheme = themes.firstIndex(of: themeButton){
                cvc.themeCode = gameTheme
            }
        }
    }
    
}
