//
//  FetchGallery.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 29/05/25.
//

import Combine

/// @mockable
protocol FetchGallery {
  func execute(_ page: Int) -> AnyPublisher<GalleryResponse, Error>
}

class FetchGalleryImpl: FetchGallery {
  private let galleryRepository: GalleryRepository

  init(_ galleryRepository: GalleryRepository) {
    self.galleryRepository = galleryRepository
  }

  func execute(_ page: Int) -> AnyPublisher<GalleryResponse, Error> {
    return galleryRepository.fetchGalleryItems(page)
  }
}

