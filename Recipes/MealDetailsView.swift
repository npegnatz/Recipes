//
//  MealView.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/27/24.
//

import Foundation
import SwiftUI

//www.themealdb.com/api/json/v1/1/lookup.php?i=52772
struct MealDetails: Decodable {
  let idMeal: String
  let strMeal: String
  let strInstructions: String
  let strMealThumb: String
  let strCategory: String
  let strTags: String
  let strSource: String
  //let ingredients: [String]
}

struct MealDetailsResponse: Decodable {
  let meals: [MealDetails]
}

class MealDetailViewModel: ObservableObject {
  @Published var mealDetail: MealDetails?
  
  func fetchMealDetail(mealID: String) {
    guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)") else { return }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else { return }
      let mealDetailsResponse = try? JSONDecoder().decode(MealDetailsResponse.self, from: data)
      DispatchQueue.main.async {
        self.mealDetail = mealDetailsResponse?.meals.first
      }
    }.resume()
  }
}

struct MealDetailsView: View {
  @StateObject private var viewModel = MealDetailViewModel()
  var meal: Meal
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        if let mealDetail = viewModel.mealDetail {
          AsyncImage(url: URL(string: meal.strMealThumb)) { phase in
            switch phase {
            case .empty:
              ProgressView()
            case .success(let image):
              image.resizable().aspectRatio(contentMode: .fit)
            case .failure(let error):
              Image(systemName: "photo")
            @unknown default:
              Image(systemName: "photo")
            }
          }
          
          VStack(alignment: .leading, spacing: 20) {
            Text(mealDetail.strMeal)
              .font(.title)
            
            Spacer()
            
            Text("Instructions")
              .font(.headline)
            Text(mealDetail.strInstructions)
          }
          .padding()
        } else {
          ProgressView()
        }
      }
      .onAppear {
        viewModel.fetchMealDetail(mealID: meal.idMeal)
      }
    }
  }
}

#Preview {
  MealDetailsView(meal: Meal(idMeal: "52893", strMeal: "Apple & Blackberry Crumble", strMealThumb: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"))
}
