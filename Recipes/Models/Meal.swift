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
  let id: String
  let name: String
  let thumbnailUrl: String
  
  enum MealCodingKeys: String, CodingKey {
    case idMeal, strMeal, strMealThumb
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MealCodingKeys.self)
    id = try container.decode(String.self, forKey: .idMeal)
    name = try container.decode(String.self, forKey: .strMeal)
    thumbnailUrl = try container.decode(String.self, forKey: .strMealThumb)
  }
  
  init(id: String, name: String, thumbnailUrl: String) {
    self.id = id
    self.name = name
    self.thumbnailUrl = thumbnailUrl
  }
  
  @ViewBuilder
  func imageView() -> some View {
    AsyncImage(url: URL(string: self.thumbnailUrl)) { image in
      image
        .resizable()
        .scaledToFill()
    } placeholder: {
      ProgressView()
    }
  }
}
