//
//  RoundImageView.swift
//  CardGameApp
//
//  Created by joon-ho kil on 7/15/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import UIKit

class RoundImageView: UIView {
    override func awakeFromNib() {
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
