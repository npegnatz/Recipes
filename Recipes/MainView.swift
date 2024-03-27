//
//  ContentView.swift
//  Recipes
//
//  Created by Secondary on 3/27/24.
//

import SwiftUI

struct Meal: Identifiable, Decodable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    var id: String { idMeal }
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
    
    var body: some View {
        NavigationView {
            List(viewModel.meals.sorted { $0.strMeal < $1.strMeal }) { meal in
                HStack {
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
                    Text(meal.strMeal)
                }
            }
            .navigationTitle("Desserts")
            .onAppear {
                viewModel.fetchDesserts()
            }
        }
    }
}

#Preview {
    MainView()
}
