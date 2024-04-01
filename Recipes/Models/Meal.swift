//
//  Meal.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/29/24.
//

import Foundation

/** Model for a dessert meal  */
struct Meal: Identifiable, Decodable {
  let idMeal: String
  let strMeal: String
  let strMealThumb: String
  var id: String { idMeal }
}
