//
//  MealDetailsViewModel.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/29/24.
//

import Foundation

class MealDetailsViewModel: ObservableObject {
  @Published var mealDetails: MealDetails?
  
  func fetchMealDetails(mealID: String) {
    guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)") else { return }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else { return }
      let mealDetailsResponse = try? JSONDecoder().decode(MealDetailsResponse.self, from: data)
      DispatchQueue.main.async {
        self.mealDetails = mealDetailsResponse?.meals.first
      }
    }.resume()
  }
}

struct MealDetailsResponse: Decodable {
  let meals: [MealDetails]
}
