//
//  FoundationPilesViewModel.swift
//  CardGameApp
//
//  Created by yuaming on 18/05/2018.
//  Copyright © 2018 yuaming. All rights reserved.
//

import Foundation

class FoundationPilesViewModel {
  private var foundationPiles: FoundationPiles
  var delegate: FoundationPilesViewControllerDelegate?
  
  init(_ foundationPiles: FoundationPiles) {
    self.foundationPiles = foundationPiles
  }
  
  func addCardViewModels() {
    guard isAvailable else {
      (1...ViewSettings.foundationCount).forEach { setEmptyView($0) }
      return
    }
  }
  
  var isAvailable: Bool {
    return foundationPiles.count > 0
  }
}

private extension FoundationPilesViewModel {
  func setEmptyView(_ pileIndex: Int) {
    delegate?.setEmptyView(pileIndex)
  }
}