//
//  Extensions.swift
//  Recipes
//
//  Created by Other on 3/31/24.
//

import Foundation

extension String {
  func integerSuffix() -> Int? {
      let nonDigitCharacterSet = CharacterSet.decimalDigits.inverted
      let components = self.components(separatedBy: nonDigitCharacterSet)
      if let lastComponent = components.last, let number = Int(lastComponent) {
          return number
      }
      return nil
  }
}
