//
//  NetworkTests.swift
//  RecipesTests
//
//  Created by Other on 6/24/24.
//

import Foundation
import XCTest
@testable import Recipes

class APIServiceTests: XCTestCase {
  
  var sut: APIService<Meal>!
  
  override func setUp() {
    super.setUp()
    sut = APIService<Meal>()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  func testFetchSuccess() async throws {
    let expectation = XCTestExpectation(description: "Fetch meals")
    let mockURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    do {
      try await sut.fetch(url: mockURL)
      expectation.fulfill()
    } catch {
      XCTFail("Fetch should not throw an error: \(error)")
    }
    
    await fulfillment(of: [expectation], timeout: 5.0)
    XCTAssertFalse(sut.data.isEmpty, "Data should not be empty after successful fetch")
  }
  
  func testFetchInvalidURL() async {
    let invalidURL = "invalid-url"
    do {
      try await sut.fetch(url: invalidURL)
      XCTFail("Fetch should throw an error for invalid URL")
    } catch {
      XCTAssertTrue(true, "Fetch should throw an error for invalid URL")
    }
  }
  
  func testDecodingFailure() async {
    let mockURL = "https://www.themealdb.com/api/json/v1/1/categories.php"
    do {
      try await sut.fetch(url: mockURL)
      XCTFail("Fetch should throw a decoding error")
    } catch {
      XCTAssertTrue(error is DecodingError, "Error should be a DecodingError")
    }
  }
}
