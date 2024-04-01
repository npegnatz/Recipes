//
//  MealDetails.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/29/24.
//

import Foundation

/** Model for more detailed dessert info (instructions, ingredients, category, tags) */
struct MealDetails: Decodable {
  let idMeal: String
  let strMeal: String
  let strInstructions: String
  let strMealThumb: String
  let strCategory: String?
  let strTags: [String]
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
    strCategory = try container.decode(String?.self, forKey: .strCategory)
    strTags = (try? container.decode(String.self, forKey: .strTags))?.components(separatedBy: ",") ?? [String]()
    strSource = try container.decode(String?.self, forKey: .strSource)
    
    
    var ingredientsTemp = [Ingredient]()
    if let ingredientContainer = try? decoder.container(keyedBy: OtherKeys.self) {
      let ingredientKeys = ingredientContainer.allKeys.filter { $0.stringValue.starts(with: "strIngredient") }.sorted { $0.index < $1.index }
      let measureKeys = ingredientContainer.allKeys.filter { $0.stringValue.starts(with: "strMeasure") }.sorted { $0.index < $1.index }
      
      for i in 0..<ingredientKeys.count {
        if let name = try? ingredientContainer.decode(String.self, forKey: ingredientKeys[i]), let measure = try? ingredientContainer.decode(String.self, forKey: measureKeys[i]), !name.isEmpty {
          ingredientsTemp.append(Ingredient(name: name, measure: measure))
        }
      }
    }
    ingredients = ingredientsTemp
  }
}
