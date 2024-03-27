//
//  MealView.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/27/24.
//

import Foundation
import SwiftUI

struct MealView: View {
  @State var meal: Meal
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
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
        
        Spacer()
      }
      .ignoresSafeArea()
    }
  }
}

#Preview {
  MealView(meal: Meal(idMeal: "52893", strMeal: "Apple & Blackberry Crumble", strMealThumb: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"))
}
