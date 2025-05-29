//
//  HomeViewAction.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 29/05/25.
//


enum HomeAction: Equatable {
  case showLoading
  case hideLoading
  case resetGallery
  case startSearchMode
  case resetSearchMode
  case addItems(_ response: GalleryResponse, _ query: String? = nil)
  case showError
}


enum HomeErrorState: Equatable {
  case errorEmptyData
  case errorOnScroll
}

struct HomeViewState: Equatable, Hashable {
  private(set) var isLoading: Bool = false
  private(set) var gallery: [Gallery] = []
  private(set) var currentPage: Int = 0
  private(set) var imageUrl: String = ""
  private(set) var isSearchMode: Bool = false
  private(set) var query: String = ""
  private(set) var error: HomeErrorState? = nil
  
  mutating func update(_ action: HomeAction) {
    switch(action) {
    case .showLoading:
      error = nil
      isLoading = true
    case .hideLoading:
      isLoading = false
    case .resetGallery:
      gallery.removeAll()
      currentPage = 0
    case .startSearchMode:
      isSearchMode = true
    case .resetSearchMode:
      isSearchMode = false
    case .addItems(let response, let query):
      let uniqueElements = response.data.filter { gallery.contains($0) == false }
      gallery.append(contentsOf: uniqueElements)
      currentPage = response.pagination.currentPage
      imageUrl = response.config.iiifUrl
      if let query = query {
        self.query = query
      }
    case .showError:
      if gallery.count == 0 {
        error = .errorEmptyData
      } else {
        error = .errorOnScroll
      }
    }
  }
}
