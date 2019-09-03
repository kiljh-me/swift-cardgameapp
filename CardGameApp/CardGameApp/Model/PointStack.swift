//
//  PointStack.swift
//  CardGameApp
//
//  Created by joon-ho kil on 7/23/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import Foundation

struct PointStack {
    private var cards = [Card]()
    
    mutating func appandToLast(_ card: Card) {
        cards.append(card)
    }
    
    func getLastCard() -> Card? {
        return cards.last
    }
    
    init(_ card: Card) {
        cards.append(card)
    }
}
