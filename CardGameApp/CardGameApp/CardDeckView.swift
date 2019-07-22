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
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func showCardBack() {
        let image: UIImage = UIImage(named: "card-back.png") ?? UIImage()
        backCardView = UIImageView(image: image)
        backCardView.frame = CGRect(x: 350.0, y: 20.0, width: 50.0, height: 63.5)
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
                let coordinateX = Double(295)
                let coordinateY = Double(20)
                
                let image: UIImage = UIImage(named: cardImageName)!
                let imageView = UIImageView(image: image)
                
                imageView.frame = CGRect(x: Double(coordinateX), y: coordinateY, width: 50.0, height: 63.5)
                self.addSubview(imageView)
            })
        } catch {
            backCardView.removeFromSuperview()
            showRefresh()
        }
    }
    
    private func showRefresh() {
        let image: UIImage = UIImage(named: "refresh.png") ?? UIImage()
        refreshView = UIImageView(image: image)
        refreshView.frame = CGRect(x: 363.0, y: 36.0, width: 30.0, height: 30.0)
        self.addSubview(refreshView)
    }
}
