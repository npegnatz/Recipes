//
//  Ingredient.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/29/24.
//

import Foundation

/** Model for an ingredient name/measure combo  */
struct Ingredient: Identifiable {
  let id = UUID()
  let name: String
  let measure: String
}
