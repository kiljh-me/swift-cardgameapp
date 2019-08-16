//
//  CardView.swift
//  CardGameApp
//
//  Created by joon-ho kil on 7/16/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import UIKit

protocol CardStackDelegate {
    func doubleTapCard(column: Int, row: Int)
    func moveToPoint(column: Int, row: Int)
    func moveToStack(column: Int, row: Int, toColumn: Int) -> Bool
    func isMovableCard(column: Int, row: Int) -> Bool
}

class CardStackView: UIView {
    var stackView = Array(repeating: [UIImageView](), count: 7)
    var delegate: CardStackDelegate?
    var originCenter: CGPoint?
    var cardStack: ShowableToCardStack?
    
    func removeSubViews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        stackView = Array(repeating: [UIImageView](), count: 7)
    }
    
    func refreshCardStack() {
        for column in 0..<7 {
            refreshCardStackColumn(column)
        }
    }
    
    func refreshCardStackColumn(_ column: Int) {
        for view in stackView[column] {
            view.removeFromSuperview()
        }
        
        stackView[column].removeAll()
        
        guard let maxRow = cardStack?.getCardStackRow(column: column) else {
            return
        }
        
        for row in 0..<maxRow {
            showCard(column: column, row: row)
        }
    }

    func showCard(column: Int, row: Int) {
        cardStack?.showToCardStack(column: column, row: row, handler: { (cardImageName) in
            let coordinateX = 20 + 55 * column
            let coordinateY = 20 * row
        
            let image: UIImage = UIImage(named: cardImageName) ?? UIImage()
            let imageView = UIImageView(image: image)
            
            imageView.frame = CGRect(x: coordinateX, y: coordinateY, width: 50, height: 63)
            self.addSubview(imageView)
            imageView.isUserInteractionEnabled = true
            
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(recognizer:)))
            doubleTapGesture.numberOfTapsRequired = 2
            
            let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(draggingView))
            imageView.addGestureRecognizer(dragGesture)
            imageView.addGestureRecognizer(doubleTapGesture)
            
            stackView[column].append(imageView)
        })
    }
    
    @objc func handleTapGesture(recognizer: UITapGestureRecognizer) {
        var row = -1
        var column = -1
        
        for (i, stack) in stackView.enumerated() {
            if let j = stack.firstIndex(of: recognizer.view as! UIImageView) {
                column = i
                row = j
            }
        }
        
        if row >= 0 && column >= 0 {
            delegate?.doubleTapCard(column: column, row: row)
        }
    }
    
    func animateToPoint(column: Int, row: Int, pointIndex: Int) -> UIImageView? {
        var view: UIImageView?
        
        UIView.animate(withDuration: 0.15, animations: {
                    self.stackView[column][row].frame = CGRect(x: 20 + 55 * pointIndex, y: -80, width: 50, height: 63)
        })
        
        view = self.stackView[column][row]
        stackView[column].remove(at: row)
        
        return view
    }
    
    func animateToStack(column: Int, row: Int, toColumn: Int) {
        let toRow = stackView[toColumn].count
        
        UIImageView.animate(withDuration: 0.15, animations: {
            self.stackView[column][row].frame = CGRect(x: 20 + 55 * toColumn, y: 20 * toRow, width: 50, height: 63)
        })
    }
    
    @objc func draggingView(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        let draggedView = sender.view!
        var row = -1
        var column = -1
        
        if sender.state == .began {
           originCenter = draggedView.center
        }
        
        for (i, stack) in stackView.enumerated() {
            if let j = stack.firstIndex(of: draggedView as! UIImageView) {
                column = i
                row = j
            }
        }
        
        if delegate?.isMovableCard(column: column, row: row) ?? false {
            for index in row...stackView[column].count-1 {
                stackView[column][index].center = CGPoint(x: point.x, y: point.y+CGFloat(20*(index-row)))
            }
            
            if sender.state == .ended {
                if point.y <= 0 {
                    delegate?.moveToPoint(column: column, row: row)
                } else {
                    let toColumn: Int
                    switch point.x {
                    case 0 ... 20 + 55 * 1:
                        toColumn = 0
                    case 0 ... 20 + 55 * 2:
                        toColumn = 1
                    case 0 ... 20 + 55 * 3:
                        toColumn = 2
                    case 0 ... 20 + 55 * 4:
                        toColumn = 3
                    case 0 ... 20 + 55 * 5:
                        toColumn = 4
                    case 0 ... 20 + 55 * 6:
                        toColumn = 5
                    default:
                        toColumn = 6
                    }
                    
                    
                    if !(delegate?.moveToStack(column: column, row: row, toColumn: toColumn))! {
                        refreshCardStackColumn(column)
                        refreshCardStackColumn(toColumn)
                    }
                }
            }
        }
    }
}
