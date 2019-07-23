//
//  CardView.swift
//  CardGameApp
//
//  Created by joon-ho kil on 7/16/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import UIKit

class CardStackView: UIView {
    func removeSubViews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    func showCardStack(_ cardStack: ShowableToCardStack) {
        for index in 0..<7 {
            let maxRow = cardStack.getCardStackRow(column: index)
            
            for row in 0..<maxRow {
                cardStack.showToCardStack(index, row, handler: { (cardImageName) in
                    let coordinateX = 20 + 55 * index
                    let coordinateY = 20 * row
                    
                    let image: UIImage = UIImage(named: cardImageName) ?? UIImage()
                    let imageView = UIImageView(image: image)
                    
                    imageView.frame = CGRect(x: coordinateX, y: coordinateY, width: 50, height: 63)
                    self.addSubview(imageView)
                })
            }
        }
    }
}
