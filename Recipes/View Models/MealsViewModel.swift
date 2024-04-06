//
//  MealViewModel.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/29/24.
//

import Foundation

/** ViewModel for fetching dessert meals */
class MealsViewModel: ObservableObject {
  @Published var meals = [Meal]()
  
  func fetchDesserts() async throws {
    guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    let mealsResponse = try JSONDecoder().decode(MealsResponse.self, from: data)
    self.meals = mealsResponse.meals
  }
}

struct MealsResponse: Decodable {
  let meals: [Meal]
}
