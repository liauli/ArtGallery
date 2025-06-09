//
//  MockFetchGallery.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 09/06/25.
//


import Combine
import Foundation

@testable import ArtGallery

class MockFetchGallery: FetchGallery {
  var whenExecute: AnyPublisher<GalleryResponse, Error>!

  func execute(_ page: Int) -> AnyPublisher<GalleryResponse, Error> {
    return whenExecute
  }
}
