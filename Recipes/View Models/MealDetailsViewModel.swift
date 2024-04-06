//
//  MealDetailsViewModel.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/29/24.
//

import Foundation

/** ViewModel for fetching dessert meal details */
class MealDetailsViewModel: ObservableObject {
  @Published var mealDetails: MealDetails?
  
  func fetchMealDetails(mealID: String) async throws {
    guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)") else { return }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    let mealDetailsResponse = try JSONDecoder().decode(MealDetailsResponse.self, from: data)
    self.mealDetails = mealDetailsResponse.meals.first
  }
}

struct MealDetailsResponse: Decodable {
  let meals: [MealDetails]
}
