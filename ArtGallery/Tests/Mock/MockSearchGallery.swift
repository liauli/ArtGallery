//
//  MockSearchGallery.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 09/06/25.
//

import Combine
import Foundation

@testable import ArtGallery

class MockSearchGallery: SearchGallery {
  var whenExecute: AnyPublisher<GalleryResponse, Error>!

  func execute(_ query: String, _ page: Int) -> AnyPublisher<GalleryResponse, Error> {
    return whenExecute
  }
}
