//
//  APIService.swift
//  Recipes
//
//  Created by Nick Egnatz on 4/6/24.
//

import Foundation

/** Networking service for fetching TheMealDB data */
class APIService<T: Decodable>: ObservableObject {
  @Published var data = [T]()
  
  func fetch(url: String) async throws {
    guard let url = URL(string: url) else { return }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let dataResponse = try JSONDecoder().decode(Response.self, from: data)
    self.data = dataResponse.meals
  }
  
  struct Response: Decodable {
    let meals: [T]
  }
}
