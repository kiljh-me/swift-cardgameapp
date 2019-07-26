//
//  ViewController.swift
//  CardGameApp
//
//  Created by joon-ho kil on 7/12/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CardStackDelegate {
    var cardGame = CardGame()
    
    @IBOutlet weak var openCardView: UIView!
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
        openCardView.addGestureRecognizer(doubleTapGesture)
        doubleTapGesture.numberOfTapsRequired = 2
        
        cardGamePlay()
        cardStackView.delegate = self
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
        let (view, column) = cardDeckView.moveToCardStack(cardGame)
        
        if let view = view {
            cardStackView.stackView[column].append(view)
        }
    }
    
    func doubleTapCard(_ column: Int, _ row: Int) {
        let index = cardGame.getMovePoint(column, row)
        if index >= 0 {
            let view = cardStackView.animateToPoint(column, row, index)
            view.frame = CGRect(x: 20 + 55 * index, y: 20, width: 50, height: 63)
            cardDeckView.addSubview(view)
        
            cardGame.openLastCard(column)
            if row >= 1 {
                cardStackView.openLastCard(cardGame, column, row-1)
            }
            return
        }
        
        let (move, count) = cardGame.getMoveStack(column, row)
        
        if move >= 0 {
            for index in 0..<count {
                cardStackView.animateToStack(column, row+index, move)
            }
            
            cardGame.openLastCard(column)
            cardStackView.openLastCard(cardGame, column, row-1)
        }
    }
}
