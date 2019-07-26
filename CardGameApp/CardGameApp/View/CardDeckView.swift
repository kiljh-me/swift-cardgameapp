//
//  CardDeckView.swift
//  CardGameApp
//
//  Created by joon-ho kil on 7/20/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import UIKit

class CardDeckView: UIView {
    var backCardView = UIView()
    var refreshView = UIView()
    var cardDeck = [UIImageView]()
    
    func showCardBack() {
        let image: UIImage = UIImage(named: ImageFileName.cardBack.rawValue) ?? UIImage()
        backCardView = UIImageView(image: image)
        backCardView.frame = CGRect(x: 350, y: 20, width: 50, height: 63)
        self.addSubview(backCardView)
    }
    
    func removeSubViews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        cardDeck = [UIImageView]()
    }
    
    func removeCardDeck() {
        for view in cardDeck {
            view.removeFromSuperview()
        }
    }
    
    func showCard(_ card: ShowableToCardDeck) {
        do {
            var imageView = UIImageView()
            
            try card.showToOneCard(handler: { (cardImageName) in
                let coordinateX = Double(295)
                let coordinateY = Double(20)
                
                let image: UIImage = UIImage(named: cardImageName) ?? UIImage()
                imageView = UIImageView(image: image)
                
                imageView.frame = CGRect(x: coordinateX, y: coordinateY, width: 50, height: 62)
                self.addSubview(imageView)
                cardDeck.append(imageView)
            })
            
            while true {
                let point = card.moveToPoint()
                
                if point >= 0 {
                    UIImageView.animate(withDuration: 0.15, animations: {
                        self.cardDeck.last?.frame = CGRect(x: 20 + 55 * point, y: 20, width: 50, height: 63)
                                        })
                    cardDeck.removeLast()
                } else {
                    break
                }
            }
            
            if card.count() == 0 {
                backCardView.removeFromSuperview()
                showRefresh()
            }
            
        } catch {
            card.refreshCardDeck()
            removeCardDeck()
            removeRefresh()
            showCardBack()
        }
    }
    
    private func showRefresh() {
        let image: UIImage = UIImage(named: ImageFileName.refresh.rawValue) ?? UIImage()
        refreshView = UIImageView(image: image)
        refreshView.frame = CGRect(x: 366, y: 36, width: 30, height: 30)
        self.addSubview(refreshView)
    }
    
    private func removeRefresh() {
        backCardView.removeFromSuperview()
        refreshView.removeFromSuperview()
    }
    
    func moveToCardStack(_ card: ShowableToCardDeck & ShowableToCardStack) -> (UIImageView?, Int) {
        let column = card.moveToStack()
        
        if column < 0 {
            return (nil, -1)
        }
        
        let row = card.getCardStackRow(column: column)
        
        guard let cardView = cardDeck.last else {
            return (nil, -1)
        }
        
        cardDeck.removeLast()
        
        UIImageView.animate(withDuration: 0.15, animations: {
            cardView.frame = CGRect(x: 20 + 55 * column, y: 100 + 20 * (row - 1), width: 50, height: 63)
        })
        
        return (cardView, column)
    }
}
