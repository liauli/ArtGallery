//
//  DummyBuilder.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 08/06/25.
//

@testable import ArtGallery

func randomString(_ length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map { _ in letters.randomElement()! })
}

func createGalleryResponse(_ page: Int = 1) -> GalleryResponse {
  return GalleryResponse(
    pagination: createPagination(page),
    data: createGalleryItems(),
    config: createConfig()
  )
}

func createGalleryItems() -> [Gallery] {
  return [
    createGallery(),
    createGallery(),
    createGallery(imageId: nil)
  ]
}

func createPagination(_ page: Int) -> Pagination {
  return Pagination(
    total: 1,
    limit: 20,
    offset: 2,
    totalPages: 100,
    currentPage: page
  )
}

func createConfig() -> Config {
  return Config(iiifUrl: randomString(2))
}

func createGallery(imageId: String? = randomString(2)) -> Gallery {
    return Gallery(id: Int.random(in: 0..<100), imageId: imageId, creditLine: randomString(3), desc: randomString(3), shortDescription: randomString(3), publicationHistory: randomString(3), exhibitionHistory: randomString(3), artistTitle: randomString(3), placeOfOrigin: randomString(3), provenanceText: randomString(3), title: randomString(3))
}

func createGalleryResponse(count: Int = 1, query: String? = nil) -> GalleryResponse {
    let galleries = (1...count).map { _ in  createGallery() }
    return GalleryResponse(
        pagination: .init(total: count, limit: count, offset: 0, totalPages: 1, currentPage: 1),
        data: galleries,
        config: .init(iiifUrl: "https://test.url")
    )
}
