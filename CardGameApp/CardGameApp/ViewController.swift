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
        while true {
            let point = cardGame.moveToPoint()
            
            if point >= 0 {
                UIImageView.animate(withDuration: 0.15, animations: {
                    self.cardDeckView.openCards.last?.frame = CGRect(x: 20 + 55 * point, y: 20, width: 50, height: 63)
                })
                cardDeckView.openCards.removeLast()
            } else {
                break
            }
        }
        
        let (view, column) = cardDeckView.moveToCardStack(cardGame)
        
        if let view = view {
            cardStackView.stackView[column].append(view)
        }
        
        let blankIndex = cardGame.moveableK()
        
        if blankIndex >= 0 {
            UIImageView.animate(withDuration: 0.15, animations: {
                self.cardDeckView.openCards.last?.frame = CGRect(x: 20 + 55 * blankIndex, y: 100, width: 50, height: 63)
            })
            
            let kView = cardDeckView.openCards.removeLast()
            cardStackView.stackView[blankIndex].append(kView)
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
            for _ in 0..<count {
                cardStackView.animateToStack(cardGame, column, row, move)
            }
            
            cardGame.openLastCard(column)
            if row >= 1 {
                cardStackView.openLastCard(cardGame, column, row-1)
            }
        }
    
        if (index < 0 && move < 0) && cardGame.isK(column, row) {
            let (move, count) = cardGame.kCardMoveStackToStack(column, row)
            
            if move >= 0 {
                for _ in 0..<count {
                    cardStackView.animateToStack(cardGame, column, row, move)
                }
                
                cardGame.openLastCard(column)
                if row >= 1 {
                    cardStackView.openLastCard(cardGame, column, row-1)
                }
            }
        }
    }
}
