//
//  MealViewModel.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/29/24.
//

import Foundation

class MealsViewModel: ObservableObject {
  @Published var meals = [Meal]()
  
  func fetchDesserts() {
    guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else { return }
      
      let response = try? JSONDecoder().decode(MealsResponse.self, from: data)
      DispatchQueue.main.async {
        self.meals = response?.meals ?? []
      }
    }.resume()
  }
}

struct MealsResponse: Decodable {
  let meals: [Meal]
}
