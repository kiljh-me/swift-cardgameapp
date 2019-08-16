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
        if let view = recognizer.view {
            let (column, row) = getCoordinateView(view)
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
        
        let (column, row) = getCoordinateView(draggedView)
        
        guard delegate?.isMovableCard(column: column, row: row) ?? false else {
            return
        }
        
        for index in row...stackView[column].count-1 {
            stackView[column][index].center = CGPoint(x: point.x, y: point.y+CGFloat(20*(index-row)))
        }
        
        if sender.state == .ended {
            if point.y <= 0 {
                delegate?.moveToPoint(column: column, row: row)
                return
            }
            
            let toColumn = Int((point.x - 20) / 55)
            
            guard !(delegate?.moveToStack(column: column, row: row, toColumn: toColumn))! else {
                return
            }
            
            refreshCardStackColumn(column)
            refreshCardStackColumn(toColumn)
        }
    }
    
    private func getCoordinateView(_ view: UIView) -> (Int, Int) {
        var column = 0
        var row = 0
        
        for (i, stack) in stackView.enumerated() {
            if let j = stack.firstIndex(of: view as! UIImageView) {
                column = i
                row = j
            }
        }
        
        return (column, row)
    }
}
