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
        cardStackView.cardStack = cardGame
        
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
        cardStackView.refreshCardStack()
        cardDeckView.showCardBack()
    }
    
    @objc func handleTapGesture(recognizer: UITapGestureRecognizer) {
        while true {
            if let pointStackColumn = cardGame.moveToPointStack() {
                UIImageView.animate(withDuration: 0.15, animations: {
                    self.cardDeckView.openCards.last?.frame = CGRect(x: 20 + 55 * pointStackColumn, y: 20, width: 50, height: 63)
                })
                
                self.cardDeckView.openCards.removeLast()
                checkWin()
            } else {
                break
            }
        }
        
        let (view, column) = cardDeckView.moveToCardStack(cardGame)
        
        if let view = view {
            cardStackView.stackView[column].append(view)
        }
        
        guard let blankIndex = cardGame.moveableK() else {
            return
        }
        
        UIImageView.animate(withDuration: 0.15, animations: {
            self.cardDeckView.openCards.last?.frame = CGRect(x: 20 + 55 * blankIndex, y: 100, width: 50, height: 63)
        })
        
        let kView = cardDeckView.openCards.removeLast()
        cardStackView.stackView[blankIndex].append(kView)
    }
    
    func moveToPoint(column: Int, row: Int) {
        let index = cardGame.movePointStack(column, row)

        if let index = index, let view = cardStackView.animateToPoint(column, row, index) {
            view.frame = CGRect(x: 20 + 55 * index, y: 20, width: 50, height: 63)
            cardDeckView.addSubview(view)

            cardGame.openLastCard(column)
            cardStackView.refreshCardStackColumn(column: column)
            
            checkWin()
        }
    }
    
    func moveToStack(column: Int, row: Int, toColumn: Int) -> Bool {
        let moveInfo = cardGame.getMoveableToStack(column: column, row: row, toColumn: toColumn)
        
        if let toColumn = moveInfo.0 {
            for _ in 0..<moveInfo.1
            {
                cardStackView.animateToStack(column, row, toColumn)
            }
            
            cardGame.openLastCard(column)

            cardStackView.refreshCardStackColumn(column: column)
            cardStackView.refreshCardStackColumn(column: toColumn)
            
            return true
        }
        
        if cardGame.isMovableK(column: column, row: row, toColumn: toColumn) {
            let (toCloumn, moveCardCount) = cardGame.kCardMoveStackToStack(column, row)
            if let toCloumn = toCloumn {
                for _ in 0..<moveCardCount {
                    cardStackView.animateToStack(column, row, toCloumn)
                }
                
                cardGame.openLastCard(column)
                cardStackView.refreshCardStackColumn(column: column)
                cardStackView.refreshCardStackColumn(column: toColumn)
            }
            
            return true
        }
        
        return false
    }
    
    func doubleTapCard(column: Int, row: Int) {
        let index = cardGame.movePointStack(column, row)
        
        if let index = index, let view = cardStackView.animateToPoint(column, row, index) {
            view.frame = CGRect(x: 20 + 55 * index, y: 20, width: 50, height: 63)
            
            cardDeckView.addSubview(view)
            
            cardGame.openLastCard(column)
            cardStackView.refreshCardStackColumn(column: column)
            
            checkWin()
            
            return
        }
        
        let (toColumn, moveCardCount) = cardGame.getMoveStack(column, row)
        
        if let toColumn = toColumn {
            for _ in 0..<moveCardCount {
                cardStackView.animateToStack(column, row, toColumn)
            }
            
            cardGame.openLastCard(column)
            cardStackView.refreshCardStackColumn(column: column)
            cardStackView.refreshCardStackColumn(column: toColumn)
        
            return
        }
    
        if cardGame.isK(column, row) {
            let (toColumn, moveCardCount) = cardGame.kCardMoveStackToStack(column, row)
            if let toColumn = toColumn {
                for _ in 0..<moveCardCount {
                    cardStackView.animateToStack(column, row, toColumn)
                }
                
                cardGame.openLastCard(column)
                cardStackView.refreshCardStackColumn(column: column)
                cardStackView.refreshCardStackColumn(column: toColumn)
            }
        }
    }
    
    func isMovableCard(column: Int, row: Int) -> Bool {
        return cardGame.isMovableCard(column: column, row: row)
    }
    
    private func checkWin() {
        let cardExistArrayCount = cardStackView.stackView.map { (viewArray) -> Int in
            return viewArray.count
            }.filter { (count) -> Bool in
                return count > 0
            }.count
        if cardExistArrayCount == 0 {
            let alert = UIAlertController(title: "성공", message: "게임을 승리하셨습니다.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "닫기", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
