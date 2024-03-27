//
//  ContentView.swift
//  Recipes
//
//  Created by Nick Egnatz on 3/27/24.
//

import SwiftUI

struct Meal: Identifiable, Decodable {
  let idMeal: String
  let strMeal: String
  let strMealThumb: String
  var id: String { idMeal }
  
  @ViewBuilder
  func imageView() -> some View {
    AsyncImage(url: URL(string: strMealThumb)) { phase in
      switch phase {
      case .empty:
        ProgressView()
      case .success(let image):
        image.resizable().aspectRatio(contentMode: .fit)
      case .failure(let error):
        Image(systemName: "exclamationmark.square.fill")
      @unknown default:
        Image(systemName: "questionmark.square.fill")
      }
    }
  }
}

struct MealsResponse: Decodable {
  let meals: [Meal]
}

class MealsViewModel: ObservableObject {
  @Published var meals = [Meal]()
  
  func fetchDesserts() {
    guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else { return }
      
      let response = try? JSONDecoder().decode(MealsResponse.self, from: data)
      DispatchQueue.main.async {
        self.meals = response?.meals ?? []
      }
    }.resume()
  }
}

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
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onTapGesture {
              selectedMeal = meal
            }
          }
        }
        .padding()
      }
      .navigationTitle("Desserts")
      .sheet(item: $selectedMeal, onDismiss: {
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
