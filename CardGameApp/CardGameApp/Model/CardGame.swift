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
            return 0
        }
        
        if card.isPoint(pointStack) {
            cardDeck.removeOpenCard()
            
            var sameSuitCardStack = pointStack.filter { (stack) -> Bool in
                return stack.getLastCard()?.isEqualToSuit(card) ?? false
            }
            
            if sameSuitCardStack.count > 0 {
                sameSuitCardStack[0].appandToLast(card)
            } else {
                pointStack.append(PointStack(card))
            }
            
            dump(pointStack)
            return pointStack.count
        }
        
        return 0
    }
}
