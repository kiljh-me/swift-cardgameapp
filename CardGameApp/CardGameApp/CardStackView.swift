//
//  CardView.swift
//  CardGameApp
//
//  Created by joon-ho kil on 7/16/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import UIKit

class CardStackView: UIView {
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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
                    let coordinateX = Double(20 + 55 * index)
                    let coordinateY = Double(20 * row)
                    
                    let image: UIImage = UIImage(named: cardImageName) ?? UIImage()
                    let imageView = UIImageView(image: image)
                    
                    imageView.frame = CGRect(x: Double(coordinateX), y: coordinateY, width: 50.0, height: 63.5)
                    self.addSubview(imageView)
                })
            }
        }
    }
}
