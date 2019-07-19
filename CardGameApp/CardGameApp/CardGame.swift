//
//  CardGame.swift
//  CardGame
//
//  Created by joon-ho kil on 5/23/19.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

struct CardGame: ShowableToCardStack {
    private var cardDeck =  CardDeck()
    private var cardStack = [CardStack]()
    
    /// 게임 종료
    mutating func end() {
        cardStack.removeAll()
        cardDeck = CardDeck()
    }
    
    /// 게임 시작
    mutating func start() {
        for index in 1...7 {
            cardStack.append(CardStack(layer: index, cardDeck: cardDeck))
        }
    }
    
    func showToCardStack(_ column: Int, _ row: Int, handler: (String) -> ()) {
        cardStack[column].showToCards(column, row, handler: handler)
    }
    
    func getCardStackRow(column: Int) -> Int {
        return cardStack[column].getCardsCount()
    }
}
