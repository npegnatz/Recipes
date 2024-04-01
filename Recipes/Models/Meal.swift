//
//  Meal.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/29/24.
//

import Foundation
import SwiftUI

/** Model for a dessert meal  */
struct Meal: Identifiable, Decodable {
  let idMeal: String
  let strMeal: String
  let strMealThumb: String
  var id: String { idMeal }
  
  @ViewBuilder
  func imageView() -> some View {
    AsyncImage(url: URL(string: self.strMealThumb)) { image in
      image
        .resizable()
        .scaledToFill()
    } placeholder: {
      ProgressView()
    }
  }
}
