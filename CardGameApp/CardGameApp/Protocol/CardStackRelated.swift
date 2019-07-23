//
//  ShowableToImage.swift
//  CardGameApp
//
//  Created by joon-ho kil on 7/16/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import Foundation

protocol ShowableToCardStack {
    func getCardStackRow(column: Int) -> Int
    func showToCardStack(_ column: Int, _ row: Int, handler: (String) -> ())
}

protocol ShowableToCards {
    func getCardsCount() -> Int
    func showToCardStack(_ column: Int, _ row: Int, handler: (String) -> ())
}

protocol ShowableToImage {
    func showToImage(handler: (String) -> ())
}

protocol ShowableToCardDeck {
    func showToOneCard(handler: (String) -> ()) throws
}

protocol
