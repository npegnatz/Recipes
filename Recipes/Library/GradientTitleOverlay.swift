//
//  GradientTitleOverlay.swift
//  Recipes
//
//  Created by Nick Egnatz on 4/1/24.
//

import Foundation
import SwiftUI

/** ViewModifier that overlays a gradient and a title text over the content  */
struct GradientTitleOverlay: ViewModifier {
  let title: String
  let font: Font
  
  func body(content: Content) -> some View {
    content
      .overlay {
        ZStack(alignment: .bottomLeading) {
          LinearGradient(colors: [Color.clear, Color.black], startPoint: .top, endPoint: .bottom)
            .padding(-50)
          
          Text(title)
            .font(font)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
      }
  }
}

extension View {
  func gradientTitleOverlay(title: String, font: Font) -> some View {
    self.modifier(GradientTitleOverlay(title: title, font: font))
  }
}
