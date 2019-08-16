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
    private var cardStacks = CardStacks()
    private var pointStacks = [PointStack]()

    /// 게임 종료
    func end() {
        cardDeck = CardDeck()
        cardStacks = CardStacks()
        pointStacks.removeAll()
    }
    
    /// 게임 시작
    func start() {
        cardStacks.start(cardDeck, count: 7)
    }
    
    func showToCardStack(column: Int, row: Int, handler: (String) -> ()) {
        cardStacks.showToCardStack(column, row, handler: handler)
    }
    
    func getCardStackRow(column: Int) -> Int {
        return cardStacks.getCardStackRow(column)
    }
    
    func showToOneCard(handler: (String) -> ()) throws {
        let card = try cardDeck.openOne()
        
        card.open()
        card.showToImage(handler: handler)
    }
    
    func refreshCardDeck() {
        cardDeck.refresh()
    }
    
    func moveToPointStack() -> Int? {
        guard let card = cardDeck.getOpenCard() else {
            return nil
        }
        
        let point = card.isPoint(pointStacks)
        
        if point < 0 {
            return nil
        }
        
        cardDeck.removeOpenCard()
        
        if pointStacks.count == point {
            pointStacks.append(PointStack(card))
            
            return point
        }
        
        pointStacks[point].appandToLast(card)
        
        return point
    }
    
    func moveToCardStack() -> Int? {
        guard let card = cardDeck.getOpenCard() else {
            return nil
        }
        
        if let index = card.isCardStack(cardStacks) {
            cardStacks.appendToLast(column: index, card)
            cardDeck.removeOpenCard()
            
            return index
        }
        
        return nil
    }
    
    func count() -> Int {
        return cardDeck.count()
    }
    
    func movePointStack(column: Int, row: Int) -> Int? {
        if row != cardStacks.getCardsCount(column: column)-1 {
            return nil
        }
        
        guard let card = cardStacks.getIndexCard(column: column, row: row) else {
            return nil
        }
        
        let point = card.isPoint(pointStacks)
        
        if point < 0 {
            return nil
        }
        
        cardStacks.removeLast(column: column)
        
        if pointStacks.count == point {
            pointStacks.append(PointStack(card))
            
            return point
        }
        
        pointStacks[point].appandToLast(card)
        
        return point
    }
    
    func openLastCard(_ column: Int) {
        cardStacks.openLastCard(column: column)
        
    }
    
    func getMoveStack(column: Int, row: Int) -> (Int?, Int) {
        let cardStacksPart = cardStacks.getCardStacksPart(firstColumn: column)
        
        guard let card = cardStacks.getIndexCard(column: column, row: row) else {
            return (nil, 0)
        }
        
        if var index = card.isCardStack(cardStacksPart), index >= 0 {
            index += column
            
            let count = moveCards(column: column, row: row, toColumn: index)
            
            return (index, count)
        } else if let index = card.isCardStack(cardStacks), index >= 0 {
            let count = moveCards(column: column, row: row, toColumn: index)
            
            return (index, count)
        }
        
        return (nil, 0)
    }
    
    func getMoveableToStack(column: Int, row: Int, toColumn: Int) -> (Int?, Int) {
        let cardStacksPart = cardStacks.getCardStacksOne(column: toColumn)
        
        guard let card = cardStacks.getIndexCard(column: column, row: row) else {
            return (nil, 0)
        }
        
        if var index = card.isCardStack(cardStacksPart), index >= 0 {
            let count = moveCards(column: column, row: row, toColumn: toColumn)
            
            return (toColumn, count)
        }
        
        return (nil, 0)
    }
    
    func moveableK() -> Int? {
        guard cardDeck.isCardKAtOpenCardTop() else {
            return nil
        }
        
        guard let cardK = cardDeck.getOpenCard() else {
            return nil
        }
        
        cardDeck.removeOpenCard()
        
        guard let index = blankIndexAtCardStack() else {
            return nil
        }
        
        cardStacks.appendToLast(column: index, cardK)
        
        return index
    }
    
    private func blankIndexAtCardStack() -> Int? {
        return cardStacks.blankIndexAtCardStack()
    }
    
    func isK(column: Int, row: Int) -> Bool {
        guard let card = cardStacks.getIndexCard(column: column, row: row) else {
            return false
        }
        
        return card.isK()
    }
    
    func isMovableK(column: Int, row: Int, toColumn: Int) -> Bool {
        let cardStacksPart = cardStacks.getCardStacksOne(column: toColumn)
        
        guard let card = cardStacks.getIndexCard(column: column, row: row) else {
            return false
        }
        
        return card.isMovableK(cardStacksPart)
    }
    
    func kCardMoveStackToStack(column: Int, row: Int) -> (Int?, Int) {
        guard let arrivingColumn = blankIndexAtCardStack() else {
            return (nil, 0)
        }
        
        let count = moveCards(column: column, row: row, toColumn: arrivingColumn)
        
        return (arrivingColumn, count)
    }
    
    func moveCards(column: Int, row: Int, toColumn: Int) -> Int {
        var count = 0
        
        while cardStacks.getCardsCount(column: column) > row {
            if let card = cardStacks.removeIndexCard(column: column, row: row) {
                cardStacks.appendToLast(column: toColumn, card)
                count += 1
            }
        }
        
        return count
    }
    
    func isMovableCard(column: Int, row: Int) -> Bool {
        return cardStacks.isMovableCard(column: column, row: row)
    }
}
