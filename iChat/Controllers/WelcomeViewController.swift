//
//  ViewController.swift
//  iChat
//
//  Created by Armando Cáceres on 25/5/23.
//

import UIKit


class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = "iChat💥"
        
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { timer in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
    }
    
    
}

