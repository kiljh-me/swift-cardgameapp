//
//  CardGame.swift
//  CardGame
//
//  Created by joon-ho kil on 5/23/19.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

class CardGame: ShowableToCardStack, ShowableToCardDeck {
    private var cardDeck =  CardDeck()
    private var cardStack = [CardStack]()
    private var pointStack = [PointStack]()

    /// 게임 종료
    func end() {
        cardDeck = CardDeck()
        cardStack.removeAll()
        pointStack.removeAll()
    }
    
    /// 게임 시작
    func start() {
        for index in 1...7 {
            cardStack.append(CardStack(layer: index, cardDeck: cardDeck))
        }
    }
    
    func showToCardStack(_ column: Int, _ row: Int, handler: (String) -> ()) {
        cardStack[column].showToCardStack(column, row, handler: handler)
    }
    
    func getCardStackRow(column: Int) -> Int {
        return cardStack[column].getCardsCount()
    }
    
    func showToOneCard(handler: (String) -> ()) throws {
        let card = try cardDeck.openOne()
        
        card.flip()
        card.showToImage(handler: handler)
    }
    
    func refreshCardDeck() {
        cardDeck.refresh()
    }
    
    func moveToPoint() -> Int {
        guard let card = cardDeck.getOpenCard() else {
            return -1
        }
        
        let point = card.isPoint(pointStack)
        
        if point < 0 {
            return -1
        }
        
        cardDeck.removeOpenCard()
        
        if pointStack.count == point {
            pointStack.append(PointStack(card))
            
            return point
        }
        
        pointStack[point].appandToLast(card)
        
        return point
    }
    
    func moveToStack() -> Int {
        guard let card = cardDeck.getOpenCard() else {
            return -1
        }
        
        let index = card.isCardStack(cardStack)
        if index >= 0 {
            cardStack[index].appandToLast(card)
        }
        
        return index
    }
    
    func count() -> Int {
        return cardDeck.count()
    }
    
    func getMovePoint(_  column: Int, _ row: Int) -> Int {
        guard let card = cardStack[column].getIndexCard(row) else {
            return -1
        }
        
        let point = card.isPoint(pointStack)
        
        if point < 0 {
            return -1
        }
        
        cardStack[column].removeLast()
        
        if pointStack.count == point {
            pointStack.append(PointStack(card))
            
            return point
        }
        
        pointStack[point].appandToLast(card)
        
        return point
    }
    
    func openLastCard(_ column: Int) {
        cardStack[column].openLastCard()
    }
    
    
    func getMoveStack(_ column: Int, _ row: Int) -> (Int, Int) {
        let card = cardStack[column].getIndexCard(row)
        var count = 0
        
        var index = card?.isCardStack([cardStack[cardStack.index(column, offsetBy: cardStack.count-column-1)]])
        
        if let index = index, index >= 0 {
            for rowIndex in row...cardStack[column].getCardsCount()-1 {
                if let card = cardStack[column].removeIndexCard(rowIndex) {
                    cardStack[index].appandToLast(card)
                }
                count += 1
            }
            
            return (index, count)
        }
        
        index = card?.isCardStack(cardStack)
        
        if let index = index, index >= 0 {
            for rowIndex in row...cardStack[column].getCardsCount()-1 {
                if let card = cardStack[column].removeIndexCard(rowIndex) {
                    cardStack[index].appandToLast(card)
                }
                count += 1
            }
            
            return (index, count)
        }
        
        return (index ?? -1, -1)
    }
}
