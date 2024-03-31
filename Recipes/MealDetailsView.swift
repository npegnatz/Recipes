//
//  MealView.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/27/24.
//

import Foundation
import SwiftUI

/** Shows detailed information for a meal */
struct MealDetailsView: View {
  //MARK: - Variables
  @Environment(\.dismiss) var dismiss
  @StateObject private var viewModel = MealDetailsViewModel()
  @State private var isIngredientsExpanded: Bool = true
  @State private var isInstructionsExpanded: Bool = true
  var meal: Meal
  
  //MARK: - Views
  var body: some View {
    NavigationStack {
      ZStack {
        if let mealDetails = viewModel.mealDetails {
          VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
              meal.imageView()
                .aspectRatio(contentMode: .fill)
                .overlay(LinearGradient(colors: [Color.clear, Color.black.opacity(0.85)], startPoint: .top, endPoint: .bottom))
                .frame(height: 200)
              
              Text(mealDetails.strMeal)
                .font(.system(size: 25, weight: .semibold))
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            
            ScrollView {
              VStack(alignment: .leading, spacing: 20) {
                HStack {
                  ForEach([mealDetails.strCategory] + mealDetails.strTags, id: \.self) { item in
                    if let item = item {
                      Text(item)
                        .foregroundStyle(.white)
                        .font(.system(size: 13, weight: .semibold))
                        .padding(10)
                        .background(Capsule().fill(Color.primary))
                    }
                  }
                }

                GroupBox {
                  DisclosureGroup(isExpanded: $isIngredientsExpanded,
                    content: {
                      VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                      
                        ForEach(mealDetails.ingredients) { item in
                          HStack {
                            Text(item.name)
                            Spacer()
                            Text(item.measure)
                          }
                        }
                      }
                    },
                    label: { Text("Ingredients").font(.headline).foregroundStyle(Color.primary) }
                  )
                }
              
                GroupBox {
                  DisclosureGroup(isExpanded: $isInstructionsExpanded,
                    content: {
                      Text(mealDetails.strInstructions)
                        .padding(.top, 10)
                    },
                    label: { Text("Instructions").font(.headline).foregroundStyle(Color.primary) }
                  )
                }
              }
              .padding()
            }
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 15))
          }
        } else {
          ProgressView()
        }
      }
      .ignoresSafeArea()
      .toolbarBackground(.hidden, for: .navigationBar)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(action: { dismiss() }) {
            Image(systemName: "multiply.circle.fill")
              .resizable()
              .foregroundStyle(Color.white)
              .opacity(0.8)
              .frame(width: 30, height: 30)
          }
        }
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
