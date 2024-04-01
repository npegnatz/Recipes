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
        LazyVGrid(columns: columns) {
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
