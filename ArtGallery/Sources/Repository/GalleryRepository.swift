//
//  GalleryRepository.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 29/05/25.
//

import Combine
import Foundation

/// @mockable
protocol GalleryRepository {
  func fetchGalleryItems(_ page: Int) -> AnyPublisher<GalleryResponse, Error>
  func searchGallery(_ query: String, _ page: Int) -> AnyPublisher<GalleryResponse, Error>
}

class GalleryRepositoryImpl: GalleryRepository {
  private let apiService: APIService
    private let userDefaults: UserDefaults
  
  init(
    _ apiService: APIService,
    _ userDefaults: UserDefaults = .standard
  ) {
    self.apiService = apiService
      self.userDefaults = userDefaults
  }

  func fetchGalleryItems(_ page: Int) -> AnyPublisher<GalleryResponse, Error> {
      return apiService.fetchGalleryItems(page).map {[weak self] result in
          let imageUrl = result.config.iiifUrl
          self?.userDefaults.set(imageUrl, forKey: "imageUrl")
          print("imageUrl === \(imageUrl)")
          return result
      }
      .eraseToAnyPublisher()
  }
  
  
  func searchGallery(_ query: String, _ page: Int) -> AnyPublisher<GalleryResponse, Error> {
    return apiService.searchGallery(query, page)
  }
}
