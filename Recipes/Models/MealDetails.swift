//
//  MealDetails.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/29/24.
//

import Foundation

/** Model for more detailed dessert info (instructions, ingredients, category, tags) */
struct MealDetails: Decodable {
  let id: String
  let name: String
  let instructions: String
  let thumbnailUrl: String
  let category: String?
  let tags: [String]
  let source: String?
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
    id = try container.decode(String.self, forKey: .idMeal)
    name = try container.decode(String.self, forKey: .strMeal)
    instructions = try container.decode(String.self, forKey: .strInstructions)
    thumbnailUrl = try container.decode(String.self, forKey: .strMealThumb)
    category = try container.decode(String?.self, forKey: .strCategory)
    tags = (try? container.decode(String.self, forKey: .strTags))?.components(separatedBy: ",") ?? [String]()
    source = try container.decode(String?.self, forKey: .strSource)
    
    
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
