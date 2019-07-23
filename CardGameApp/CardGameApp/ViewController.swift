//
//  ViewController.swift
//  CardGameApp
//
//  Created by joon-ho kil on 7/12/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var cardGame = CardGame()
    
    @IBOutlet weak var cardStackView: CardStackView!
    @IBOutlet weak var cardDeckView: CardDeckView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_pattern")!)
        self.becomeFirstResponder()
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(recognizer:)))
        cardDeckView.addGestureRecognizer(doubleTapGesture)
        doubleTapGesture.numberOfTapsRequired = 2
        
        cardGamePlay()
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            cardGameEnd()
            cardGamePlay()
        }
    }
    
    @IBAction func cardDeckButton(_ sender: Any) {
        cardDeckView.showCard(cardGame as ShowableToCardDeck)
    }
    
    private func cardGameEnd() {
        cardStackView.removeSubViews()
        cardDeckView.removeSubViews()
        cardGame.end()
    }
    
    private func cardGamePlay() {
        cardGame.start()
        cardStackView.showCardStack(cardGame as ShowableToCardStack)
        cardDeckView.showCardBack()
    }
    
    @objc func handleTapGesture(recognizer: UITapGestureRecognizer) {
        print("Touch")
    }
}
