//
//  CardStack.swift
//  CardGameApp
//
//  Created by joon-ho kil on 7/19/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import Foundation

struct CardStack: ShowableToCards {
    private var cards = Cards()
    private var cardDeck: CardDeck

    init(layer: Int, cardDeck: CardDeck) {
        self.cardDeck = cardDeck
        
        for _ in 0..<layer {
            do {
                cards.cards.append(try self.cardDeck.removeOne())
            } catch {
                return
            }
        }
    }
    
    func showToCardStack(_ column: Int, _ row: Int, handler: (String) -> ()) {
        cards.showToCardStack(column, row, handler: handler)
    }
    
    func getCardsCount() -> Int {
        return cards.getCardsCount()
    }
}
