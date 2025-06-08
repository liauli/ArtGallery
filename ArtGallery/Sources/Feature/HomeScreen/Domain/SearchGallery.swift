//
//  SearchGallery.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 08/06/25.
//
import Combine

/// @mockable
protocol SearchGallery {
  func execute(_ query: String, _ page: Int) -> AnyPublisher<GalleryResponse, Error>
}

class SearchGalleryImpl: SearchGallery {
  private let galleryRepository: GalleryRepository

  init(_ galleryRepository: GalleryRepository) {
    self.galleryRepository = galleryRepository
  }

  func execute(_ query: String, _ page: Int) -> AnyPublisher<GalleryResponse, Error> {
    return galleryRepository.searchGallery(query, page)
  }
}
