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
    private var cardStacks = [CardStack]()
    private var pointStacks = [PointStack]()

    /// 게임 종료
    func end() {
        cardDeck = CardDeck()
        cardStacks.removeAll()
        pointStacks.removeAll()
    }
    
    /// 게임 시작
    func start() {
        for index in 1...7 {
            cardStacks.append(CardStack(layer: index, cardDeck: cardDeck))
        }
    }
    
    func showToCardStack(_ column: Int, _ row: Int, handler: (String) -> ()) {
        cardStacks[column].showToCardStack(column, row, handler: handler)
    }
    
    func getCardStackRow(column: Int) -> Int {
        return cardStacks[column].getCardsCount()
    }
    
    func showToOneCard(handler: (String) -> ()) throws {
        let card = try cardDeck.openOne()
        
        card.open()
        card.showToImage(handler: handler)
    }
    
    func refreshCardDeck() {
        cardDeck.refresh()
    }
    
    func moveToPoint() -> Int {
        guard let card = cardDeck.getOpenCard() else {
            return -1
        }
        
        let point = card.isPoint(pointStacks)
        
        if point < 0 {
            return -1
        }
        
        cardDeck.removeOpenCard()
        
        if pointStacks.count == point {
            pointStacks.append(PointStack(card))
            
            return point
        }
        
        pointStacks[point].appandToLast(card)
        
        return point
    }
    
    func moveToStack() -> Int {
        guard let card = cardDeck.getOpenCard() else {
            return -1
        }
        
        let index = card.isCardStack(cardStacks)
        if index >= 0 {
            cardStacks[index].appandToLast(card)
            cardDeck.removeOpenCard()
        }
        
        return index
    }
    
    func count() -> Int {
        return cardDeck.count()
    }
    
    func getMovePoint(_  column: Int, _ row: Int) -> Int {
        if row != cardStacks[column].getCardsCount()-1 {
            return -1
        }
        
        guard let card = cardStacks[column].getIndexCard(row) else {
            return -1
        }
        
        let point = card.isPoint(pointStacks)
        
        if point < 0 {
            return -1
        }
        
        cardStacks[column].removeLast()
        
        if pointStacks.count == point {
            pointStacks.append(PointStack(card))
            
            return point
        }
        
        pointStacks[point].appandToLast(card)
        
        return point
    }
    
    func openLastCard(_ column: Int) {
        cardStacks[column].openLastCard()
    }
    
    
    func getMoveStack(_ column: Int, _ row: Int) -> (Int, Int) {
        let card = cardStacks[column].getIndexCard(row)
        var count = 0
        
        var index = card?.isCardStack([cardStacks[cardStacks.index(column, offsetBy: cardStacks.count-column-1)]])
        
        if let index = index , index >= 0 {
            while cardStacks[column].getCardsCount() > row {
                if let card = cardStacks[column].removeIndexCard(row) {
                    cardStacks[index + column].appandToLast(card)
                    count += 1
                }
            }
            
            return (index + column, count)
        }
        
        index = card?.isCardStack(cardStacks)
        
        if let index = index, index >= 0 {
            while cardStacks[column].getCardsCount() > row {
                if let card = cardStacks[column].removeIndexCard(row) {
                    cardStacks[index].appandToLast(card)
                    count += 1
                }
            }
            
            return (index, count)
        }
        
        return (index ?? -1, -1)
    }
    
    func moveableK() -> Int {
        if cardDeck.isK() {
            guard let cardK = cardDeck.getOpenCard() else {
                return -1
            }
            cardDeck.removeOpenCard()
            
            guard let index = blankIndexToCardStack() else {
                return -1
            }
            
            cardStacks[index].appandToLast(cardK)
        }
        
        return -1
    }
    
    private func blankIndexToCardStack() -> Int? {
        for (index, cardStack) in cardStacks.enumerated() {
            if cardStack.getLastCard() == nil {
                return index
            }
        }
        
        return nil
    }
    
    func isK(_ column: Int, _ row: Int) -> Bool {
        guard let card = cardStacks[column].getIndexCard(row) else {
            return false
        }
        
        return card.isK()
    }
    
    func kCardMoveStackToStack(_ column: Int, _ row: Int) -> (Int, Int) {
        var count = 0
        
        guard let index = blankIndexToCardStack() else {
            return (-1, -1)
        }
        
        while cardStacks[column].getCardsCount() > row {
            if let card = cardStacks[column].removeIndexCard(row) {
                cardStacks[index].appandToLast(card)
                count += 1
            }
        }
        
        return (index, count)
    }
}
