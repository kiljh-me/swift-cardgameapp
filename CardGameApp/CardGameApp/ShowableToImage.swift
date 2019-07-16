//
//  ShowableToImage.swift
//  CardGameApp
//
//  Created by joon-ho kil on 7/16/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import Foundation

protocol ShowableToImage {
    func showToImage(_ index: Int, handler: (String) -> ())
}
