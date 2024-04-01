//
//  ContentView.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/27/24.
//

import SwiftUI

/** Shows a list of dessert meals */
struct MainView: View {
  //MARK: - Variables
  @StateObject private var viewModel = MealsViewModel()
  @State private var selectedMeal: Meal?
  private let gridColumns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
  
  //MARK: - Views
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVGrid(columns: gridColumns, spacing: 15) {
          ForEach(viewModel.meals) { meal in
            GeometryReader { geometry in
              ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                  image
                    .resizable()
                    .scaledToFill()
                } placeholder: {
                  ProgressView()
                }
                
                LinearGradient(colors: [Color.clear, Color.black], startPoint: .top, endPoint: .bottom)
                
                VStack {
                  Spacer()
                  Text(meal.strMeal)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                }
                .padding()
              }
              .frame(width: geometry.size.width, height: geometry.size.width)
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(RoundedRectangle(cornerRadius: 15)
              .stroke(.separator, lineWidth: 1.5))
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
        viewModel.fetchDesserts()
      }
    }
  }
}

#Preview {
  MainView()
}
