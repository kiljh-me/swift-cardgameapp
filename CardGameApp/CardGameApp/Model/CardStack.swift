//
//  CardStack.swift
//  CardGameApp
//
//  Created by joon-ho kil on 7/19/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import Foundation

struct CardStack: ShowableToCards {
    private var cards = [Card]()
    private var cardDeck: CardDeck

    init(layer: Int, cardDeck: CardDeck) {
        self.cardDeck = cardDeck
        
        for _ in 0..<layer {
            do {
                cards.append(try self.cardDeck.removeOne())
            } catch {
                return
            }
        }
        
        cards.last?.flip()
    }
    
    func showToCardStack(_ column: Int, _ row: Int, handler: (String) -> ()) {
        cards[row].showToImage(handler: handler)
    }
    
    func getCardsCount() -> Int {
        return cards.count
    }
    
    mutating func appandToLast(_ card: Card) {
        cards.append(card)
    }
    
    func getLastCard() -> Card? {
        return cards.last
    }
    
    func getIndexCard(_ index: Int) -> Card? {
        return cards[index]
    }
    
    mutating func removeLast() {
        cards.removeLast()
    }
    
    mutating func removeIndexCard(_ index: Int) -> Card? {
        let card = cards[index]
        cards.remove(at: index)
        
        return card
    }
    
    mutating func openLastCard() {
        cards.last?.open()
    }
}
