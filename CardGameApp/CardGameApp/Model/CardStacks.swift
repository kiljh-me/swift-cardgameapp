//
//  CardStacks.swift
//  CardGameApp
//
//  Created by joon-ho kil on 8/2/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import Foundation

struct CardStacks {
    private var cardStacks = [CardStack]()
    
    init() {
        self.cardStacks = [CardStack]()
    }
    
    init(cardStacks: [CardStack]) {
        self.cardStacks = cardStacks
    }
    
    mutating func start(_ cardDeck: CardDeck) {
        for index in 1...7 {
            cardStacks.append(CardStack(layer: index, cardDeck: cardDeck))
        }
    }
    
    func showToCardStack(_ column: Int, _ row: Int, handler: (String) -> ()) {
        cardStacks[column].showToCardStack(column, row, handler: handler)
    }
    
    func getCardStackRow(_ column: Int) -> Int {
        return cardStacks[column].getCardsCount()
    }
    
    func isMoveableToStack(_ card: Card) -> Int? {
        for (index, stack) in cardStacks.enumerated() {
            if (stack.getLastCard() ?? card).isNextStackThan(card) {
                return index
            }
        }
        
        return nil
    }
    
    mutating func appendToLast(column: Int, _ card: Card) {
        cardStacks[column].appendToLast(card)
    }
    
    func getCardsCount(column: Int) -> Int {
        return cardStacks[column].getCardsCount()
    }
    
    func getIndexCard(column: Int, row: Int) -> Card? {
        return cardStacks[column].getIndexCard(row)
    }
    
    mutating func removeLast(column: Int) {
        cardStacks[column].removeLast()
    }
    
    mutating func openLastCard(column: Int) {
        cardStacks[column].openLastCard()
    }
    
    mutating func removeIndexCard(column: Int, row: Int) -> Card? {
        return cardStacks[column].removeIndexCard(row)
    }
    
    func getCardStacksPart(firstColumn: Int) -> CardStacks {
        return CardStacks(cardStacks: [cardStacks[cardStacks.index(firstColumn, offsetBy: cardStacks.count-firstColumn-1)]])
    }
    
    func getCardStacksOne(column: Int) -> CardStacks {
        return CardStacks(cardStacks: [cardStacks[column]])
    }
    
    func blankIndexAtCardStack() -> Int? {
        for (index, cardStack) in cardStacks.enumerated() {
            if cardStack.getLastCard() == nil {
                return index
            }
        }
        
        return nil
    }
    
    func isMovableCard(column: Int, row: Int) -> Bool {
        return cardStacks[column].isMovableCard(row: row)
    }
}
