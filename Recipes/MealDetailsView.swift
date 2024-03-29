//
//  MealView.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/27/24.
//

import Foundation
import SwiftUI

//www.themealdb.com/api/json/v1/1/lookup.php?i=52772
struct Ingredient: Identifiable {
  let id = UUID()
  let name: String
  let measure: String
}

struct MealDetails: Decodable {
  let idMeal: String
  let strMeal: String
  let strInstructions: String
  let strMealThumb: String
  let strCategory: String?
  let strTags: String?
  let strSource: String?
  let ingredients: [Ingredient]
  
  enum MealDetailsCodingKeys: String, CodingKey {
    case idMeal, strMeal, strInstructions, strMealThumb, strCategory, strTags, strSource
  }
  
  private struct OtherKeys: CodingKey {
    let stringValue: String
    let index: Int
    var intValue: Int?
    
    init?(stringValue: String) {
      self.stringValue = stringValue
      self.index = stringValue.integerSuffix() ?? 0
      self.intValue = nil
    }
    
    init?(intValue: Int) {
      return nil
    }
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MealDetailsCodingKeys.self)
    idMeal = try container.decode(String.self, forKey: .idMeal)
    strMeal = try container.decode(String.self, forKey: .strMeal)
    strInstructions = try container.decode(String.self, forKey: .strInstructions)
    strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
    strCategory = try container.decode(String.self, forKey: .strCategory)
    strTags = try container.decode(String.self, forKey: .strTags)
    strSource = try container.decode(String.self, forKey: .strSource)
    
    
    let ingredientContainer = try decoder.container(keyedBy: OtherKeys.self)
    let ingredientKeys = ingredientContainer.allKeys.filter { $0.stringValue.starts(with: "strIngredient") }.sorted { $0.index < $1.index }
    let measureKeys = ingredientContainer.allKeys.filter { $0.stringValue.starts(with: "strMeasure") }.sorted { $0.index < $1.index }
    
    print(ingredientKeys, measureKeys)
    var ingredientsTemp = [Ingredient]()
    for i in 0..<ingredientKeys.count {
      if let name = try? ingredientContainer.decode(String.self, forKey: ingredientKeys[i]), let measure = try? ingredientContainer.decode(String.self, forKey: measureKeys[i]), !name.isEmpty {
        ingredientsTemp.append(Ingredient(name: name, measure: measure))
      }
    }
    ingredients = ingredientsTemp
  }
}

struct MealDetailsResponse: Decodable {
  let meals: [MealDetails]
}

class MealDetailViewModel: ObservableObject {
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

struct MealDetailsView: View {
  @StateObject private var viewModel = MealDetailViewModel()
  var meal: Meal
  
  var body: some View {
    NavigationStack {
      if let mealDetails = viewModel.mealDetails {
        ScrollView {
          VStack(spacing: 0) {
            meal.imageView()

            VStack(alignment: .leading, spacing: 20) {
              Text(mealDetails.strMeal)
                .font(.title)
              
              HStack {
                ForEach([mealDetails.strCategory, mealDetails.strTags], id: \.self) { item in
                  if let item = item {
                    Text(item)
                      .foregroundStyle(.white)
                      .font(.system(size: 13, weight: .semibold))
                      .padding(10)
                      .background(Capsule().fill(Color.black))
                  }
                }
              }
              
              Section("Ingredients") {
                
              }
              
              ForEach(mealDetails.ingredients) { item in
                HStack {
                  Text(item.name)
                  Text("->")
                  Text(item.measure)
                }
              }
              
              Text("Instructions")
                .font(.headline)
              Text(mealDetails.strInstructions)
            }
            .padding()
          }
        }
      } else {
        ProgressView()
      }
    }
    .onAppear {
      viewModel.fetchMealDetails(mealID: meal.idMeal)
    }
  }
}

#Preview {
  MealDetailsView(meal: Meal(idMeal: "52893", strMeal: "Apple & Blackberry Crumble", strMealThumb: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"))
}


extension String {
  func integerSuffix() -> Int? {
      let nonDigitCharacterSet = CharacterSet.decimalDigits.inverted
      let components = self.components(separatedBy: nonDigitCharacterSet)
      if let lastComponent = components.last, let number = Int(lastComponent) {
          return number
      }
      return nil
  }
}
