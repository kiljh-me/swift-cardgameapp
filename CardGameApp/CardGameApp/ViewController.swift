//
//  ViewController.swift
//  CardGameApp
//
//  Created by joon-ho kil on 7/12/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var cardGame = CardGame()
    @IBOutlet weak var cardView: CardView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_pattern")!)
        self.becomeFirstResponder()
        
        cardGamePlay()
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            removeCardViews()
            cardGamePlay()
        }
    }
    
    private func removeCardViews() {
        for view in cardView.subviews {
            view.removeFromSuperview()
        }
        
        cardGame.gameEnd()
    }
    
    private func showCardsPerParticipant(_ menu: Menu, _ participant: Participant) {
        for index in 0..<menu.getCardCount() {
            participant.showToImage(index, handler: { (cardImageName) in
                let coordinateX = Double(20 + 55 * index)
                let coordinateY = Double(100)
                
                let image: UIImage = UIImage(named: cardImageName)!
                let imageView = UIImageView(image: image)
                
                imageView.frame = CGRect(x: Double(coordinateX), y: coordinateY, width: 50.0, height: 63.5)
                cardView.addSubview(imageView)
            })
        }
    }
    
    private func cardGamePlay() {
        let menu = Menu.sevenCard
        let userCount = UserCount.one
        
        do {
            let participant = try cardGame.executeMenu(menu, userCount)
            
            showCardsPerParticipant(menu, participant.0[0])
        }
        catch let error as InputError
        {
            let alert = UIAlertController(title: "오류", message: error.localizedDescription, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "닫기", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        catch {
            
        }
    }
}

