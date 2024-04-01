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
  private let headerHeight: CGFloat = 175
  var meal: Meal
  
  //MARK: - Views
  var body: some View {
    NavigationStack {
      ZStack {
        if let mealDetails = viewModel.mealDetails {
          VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
              meal.imageView()
                .overlay(LinearGradient(colors: [Color.clear, Color.black], startPoint: .top, endPoint: .bottom))
                .frame(height: headerHeight)
              
              Text(mealDetails.strMeal)
                .font(.system(size: 25, weight: .semibold))
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            
            ScrollView {
              VStack(alignment: .leading, spacing: 20) {
                ScrollView(.horizontal, showsIndicators: false) {
                  LazyHStack {
                    ForEach([mealDetails.strCategory] + mealDetails.strTags, id: \.self) { item in
                      if let item = item {
                        Text(item)
                          .foregroundStyle(.background)
                          .font(.system(size: 13, weight: .semibold))
                          .padding(10)
                          .background(Capsule().fill(Color.primary))
                      }
                    }
                  }
                }
                
                GroupBox {
                  DisclosureGroup(isExpanded: $isIngredientsExpanded,
                    content: {
                      LazyVStack(alignment: .leading, spacing: 5) {
                        Spacer()
                      
                        ForEach(mealDetails.ingredients) { item in
                          HStack {
                            Text(item.name)
                            Spacer()
                            Text(item.measure).fontWeight(.semibold)
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
            Image(systemName: "xmark")
              .foregroundStyle(viewModel.mealDetails != nil ? Color.white : Color.primary)
              .font(.system(size: 22.5, weight: .medium))
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
