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
    
    func showCardBack() {
        let image: UIImage = UIImage(named: "card-back.png") ?? UIImage()
        backCardView = UIImageView(image: image)
        backCardView.frame = CGRect(x: 55, y: 20, width: 50, height: 63)
        self.addSubview(backCardView)
    }
    
    func removeSubViews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    func showCard(_ card: ShowableToCardDeck) {
        do {
            try card.showToOneCard(handler: { (cardImageName) in
                let coordinateX = Double(0)
                let coordinateY = Double(20)
                
                let image: UIImage = UIImage(named: cardImageName) ?? UIImage()
                let imageView = UIImageView(image: image)
                
                imageView.frame = CGRect(x: coordinateX, y: coordinateY, width: 50, height: 62)
                self.addSubview(imageView)
            })
        } catch {
            backCardView.removeFromSuperview()
            
            if !self.refreshView.isDescendant(of: self) {
                showRefresh()
            } else {
                card.refreshCardDeck()
                removeSubViews()
                showCardBack()
            }
        }
    }
    
    private func showRefresh() {
        let image: UIImage = UIImage(named: "refresh.png") ?? UIImage()
        refreshView = UIImageView(image: image)
        refreshView.frame = CGRect(x: 56, y: 36, width: 30, height: 30)
        self.addSubview(refreshView)
    }
}
