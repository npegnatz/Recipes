//
//  Meal.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/29/24.
//

import Foundation
import SwiftUI

struct Meal: Identifiable, Decodable {
  let idMeal: String
  let strMeal: String
  let strMealThumb: String
  var id: String { idMeal }
}
