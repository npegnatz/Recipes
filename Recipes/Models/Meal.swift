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
  
  @ViewBuilder
  func imageView() -> some View {
    AsyncImage(url: URL(string: strMealThumb)) { phase in
      switch phase {
      case .empty:
        ProgressView()
      case .success(let image):
        image.resizable().aspectRatio(contentMode: .fit)
      case .failure(let error):
        Image(systemName: "exclamationmark.square.fill")
      @unknown default:
        Image(systemName: "questionmark.square.fill")
      }
    }
  }
}
