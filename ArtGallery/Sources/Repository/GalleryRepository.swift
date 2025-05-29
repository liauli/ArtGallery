//
//  GalleryRepository.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 29/05/25.
//

import Combine
import Foundation

protocol GalleryRepository {
  func fetchGalleryItems(_ page: Int) -> AnyPublisher<GalleryResponse, Error>
  func searchGallery(_ query: String, _ page: Int) -> AnyPublisher<GalleryResponse, Error>
}

class GalleryRepositoryImpl: GalleryRepository {
  private let apiService: APIService
  
  init(
    _ apiService: APIService
  ) {
    self.apiService = apiService
  }

  func fetchGalleryItems(_ page: Int) -> AnyPublisher<GalleryResponse, Error> {
    return apiService.fetchGalleryItems(page).eraseToAnyPublisher()
  }
  
  
  func searchGallery(_ query: String, _ page: Int) -> AnyPublisher<GalleryResponse, Error> {
    return apiService.searchGallery(query, page)
  }
}
