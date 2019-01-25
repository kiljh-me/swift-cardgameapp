//
//  CardView.swift
//  CardGameApp
//
//  Created by Yoda Codd on 2019. 1. 13..
//  Copyright © 2019년 Drake. All rights reserved.
//

import UIKit
import os

/// 카드뷰의 정보를 넘겨줄 프로토콜
protocol CardViewInfo {
    func name() -> String
}


/// 카드 표현을 담당하는 이미지뷰
class CardView : UIImageView, CardViewInfo {
    // 카드 이름
    private var cardName = ""
    // 카드 앞면 이미지
    private var cardFrontImage = UIImage()
    // 뒷면 이미지는 공통
    private let cardBackImage = #imageLiteral(resourceName: "card-back")
    // 카드가 앞면인지 뒷면인지
    private var isFront = true
    
    init(cardInfo: CardInfo, frame: CGRect){
        self.cardName = cardInfo.name()
        let cardImage = UIImage(named: cardInfo.name()) ?? UIImage()
        self.cardFrontImage = cardImage
        // 카드이름과 표시화면이 같으면 앞면
        self.isFront = cardInfo.image() == cardInfo.name()
        super.init(frame: frame)
        // 앞뒷면 상태에 따라 이미지 표시
        self.refreshImage()
    }
    

    /// required init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// 카드뷰를 뒤집을 경우 뒤집은 후의 이미지로 교체한다
    func flip(){
        self.isFront = !self.isFront
        refreshImage()
    }
    
    /// 카드인포 내부에서 카드가 뒤집힐 경우를 위한 이미지 갱신
    func refreshImage(){
        if isFront {
            self.image = self.cardFrontImage
        } else {
            
            self.image = self.cardBackImage
        }
    }
    
    /// 프로토콜 준수
    func name() -> String {
        return self.cardName
    }
}