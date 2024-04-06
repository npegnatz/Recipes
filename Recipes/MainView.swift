//
//  ContentView.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/27/24.
//

import SwiftUI

/** A view that displays a grid of dessert meals fetched from `MealsViewModel`  */
struct MainView: View {
  //MARK: - Variables
  @StateObject private var viewModel = APIService<Meal>()
  @State private var selectedMeal: Meal?
  private let gridColumns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
  
  //MARK: - Views
  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns: gridColumns, spacing: 15) {
          ForEach(viewModel.data) { meal in
            GeometryReader { geometry in
              meal.imageView()
                .gradientTitleOverlay(title: meal.strMeal, font: .system(size: 18, weight: .semibold))
                .frame(width: geometry.size.width, height: geometry.size.width)
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(RoundedRectangle(cornerRadius: 15)
              .stroke(.separator, lineWidth: 1))
            .aspectRatio(1, contentMode: .fit)
            .onTapGesture {
              selectedMeal = meal
            }
          }
        }
        .padding()
      }
      .navigationTitle("Desserts")
      .fullScreenCover(item: $selectedMeal, onDismiss: {
        selectedMeal = nil
      }, content: { meal in
        MealDetailsView(meal: meal)
      })
      .onAppear {
        Task {
          try? await viewModel.fetch(url: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert")
        }
      }
    }
  }
}

#Preview {
  MainView()
}
