//
//  ContentView.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/27/24.
//

import SwiftUI

struct MainView: View {
  @StateObject private var viewModel = MealsViewModel()
  @State private var selectedMeal: Meal?
  
  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVGrid(columns: columns, spacing: 20) {
          ForEach(viewModel.meals) { meal in
            ZStack {
              meal.imageView()
                .overlay(LinearGradient(colors: [Color.clear, Color.black], startPoint: .top, endPoint: .bottom))
              
              VStack {
                Spacer()
                Text(meal.strMeal)
                  .fontWeight(.semibold)
                  .foregroundStyle(.white)
              }
              .padding(10)
            }
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding([.leading, .trailing], 5)
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
