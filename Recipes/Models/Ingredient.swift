//
//  Ingredient.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/29/24.
//

import Foundation

struct Ingredient: Identifiable {
  let id = UUID()
  let name: String
  let measure: String
}
