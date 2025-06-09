//
//  HomeViewModel.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 29/05/25.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
  private let fetchGallery: FetchGallery
  private let searchGallery: SearchGallery

  private var cancellables: Set<AnyCancellable> = []

  @Published private(set) var viewState: HomeViewState = HomeViewState()
  
  @Published var queryText: String = ""
  @Published var debouncedText: String = ""

  init(
    _ fetchGallery: FetchGallery,
    _ searchGallery: SearchGallery
  ) {
    self.fetchGallery = fetchGallery
    self.searchGallery = searchGallery
    setDebouncedText()
  }
  
  private func setDebouncedText() {
    $queryText
      .removeDuplicates()
      .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
      .sink(receiveValue: { [weak self] value in
          self?.debouncedText = value
      })
      .store(in: &cancellables)
  }

  func initialLoad() {
    loadData(1)
  }
  
  func checkIfLoadNext(_ id: Int) {
    if viewState.isLoading {
      return
    }
    
    if id == viewState.gallery.last?.id {
      
      if viewState.isSearchMode {
        search(viewState.query, viewState.currentPage + 1)
      } else {
        loadData(viewState.currentPage + 1)
      }
    }
  }
  
  private func loadData(_ page: Int) {
    if viewState.isSearchMode {
      viewState.update(.resetGallery)
      viewState.update(.resetSearchMode)
    }
    
    viewState.update(.showLoading)
    
    fetchGallery
      .execute(page)
      .receive(on: RunLoop.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          switch completion {
          case .finished:
            self?.viewState.update(.hideLoading)
          case .failure(_):
            self?.viewState.update(.showError)
            self?.viewState.update(.hideLoading)
          }
        },
        receiveValue: { [weak self] response in
          self?.viewState.update(.hideLoading)
          self?.viewState.update(.addItems(response))
        }
      )
      .store(in: &cancellables)
  }
  
  func search(_ query: String, _ page: Int = 1) {
    if query.isEmpty { return }
    
    viewState.update(.showLoading)
    
    if !viewState.isSearchMode || viewState.query != query {
      viewState.update(.resetGallery)
      viewState.update(.startSearchMode)
    }
    
    searchGallery
      .execute(query, page)
      .receive(on: RunLoop.main)
      .removeDuplicates()
      .sink(
        receiveCompletion: { [weak self] completion in
          switch completion {
          case .finished:
            self?.viewState.update(.hideLoading)
          case .failure(_):
            self?.viewState.update(.showError)
            self?.viewState.update(.hideLoading)
          }
        },
        receiveValue: { [weak self] result in
          self?.viewState.update(.hideLoading)
          self?.viewState.update(.addItems(result, query))
        }
      )
      .store(in: &cancellables)
  }
}
