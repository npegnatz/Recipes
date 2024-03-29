//
//  MealView.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/27/24.
//

import Foundation
import SwiftUI

struct MealDetailsView: View {
  @StateObject private var viewModel = MealDetailsViewModel()
  var meal: Meal
  
  var body: some View {
    NavigationStack {
      if let mealDetails = viewModel.mealDetails {
        ScrollView {
          VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
              meal.imageView()
                .overlay(LinearGradient(colors: [Color.clear, Color.black.opacity(0.75)], startPoint: .top, endPoint: .bottom))
              
              Text(mealDetails.strMeal)
                .font(.system(size: 25, weight: .semibold))
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            

            VStack(alignment: .leading, spacing: 20) {
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
              
              Section {
                VStack(alignment: .leading, spacing: 0) {
                  ForEach(mealDetails.ingredients) { item in
                    HStack {
                      Text(item.name)
                      Image(systemName: "arrow.right")
                      Text(item.measure)
                    }
                  }
                }
              } header: {
                Text("Ingredients")
                  .font(.headline)
              }

              Section {
                Text(mealDetails.strInstructions)
              } header: {
                Text("Instructions")
                  .font(.headline)
              }
            }
            .padding()
          }
        }
        .ignoresSafeArea()
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button(action: {}) {
              Image(systemName: "multiply.circle.fill")
                .resizable()
                .foregroundStyle(Color.white)
                .opacity(0.8)
                .frame(width: 30, height: 30)
            }
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
