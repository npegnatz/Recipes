//
//  MealView.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/27/24.
//

import Foundation
import SwiftUI

/** A view that shows detailed meal information fetched from `MealDetailsViewModel` for the given meal  */
struct MealDetailsView: View {
  //MARK: - Variables
  @StateObject private var viewModel = APIService<MealDetails>()
  @State private var isIngredientsExpanded: Bool = true
  @State private var isInstructionsExpanded: Bool = true
  @Environment(\.dismiss) private var dismiss
  private let headerHeight: CGFloat = 175
  var meal: Meal
  
  //MARK: - Views
  var body: some View {
    NavigationStack {
      ZStack {
        if let mealDetails = viewModel.data.first {
          VStack(spacing: 0) {
            /* Header View */
            meal.imageView()
              .frame(height: headerHeight)
              .gradientTitleOverlay(title: meal.strMeal, font: .system(size: 25, weight: .semibold))
            
            /* Details View */
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
                
                DetailBox("Ingredients", isExpanded: $isIngredientsExpanded) {
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
                }

                DetailBox("Instructions", isExpanded: $isInstructionsExpanded) {
                  Text(mealDetails.strInstructions)
                    .padding(.top, 10)
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
              .foregroundStyle(viewModel.data.first != nil ? Color.white : Color.primary)
              .font(.system(size: 22.5, weight: .medium))
          }
        }
      }
    }
    .onAppear {
      Task {
        try? await viewModel.fetch(url: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(meal.idMeal)")
      }
    }
  }
  
  @ViewBuilder
  func DetailBox<T: View>(_ title: String, isExpanded: Binding<Bool>, @ViewBuilder content: @escaping () -> T) -> some View {
    GroupBox {
      DisclosureGroup(
        isExpanded: isExpanded,
        content: content,
        label: {
          Text(title).font(.headline).foregroundStyle(Color.primary)
        }
      )
    }
  }
}

#Preview {
  MealDetailsView(meal: Meal(idMeal: "52893", strMeal: "Apple & Blackberry Crumble", strMealThumb: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"))
}
