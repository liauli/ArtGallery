//
//  GalleryResponse.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 29/05/25.
//
import SwiftData

struct GalleryResponse: Codable, Equatable {
  let pagination: Pagination
  let data: [Gallery]
  let config: Config
}

struct Gallery: Codable, Equatable, Hashable {
    let id: Int
    let imageId: String?
    let creditLine: String?
    let desc: String?
    let shortDescription: String?
    let publicationHistory: String?
    let exhibitionHistory: String?
    let artistTitle: String?
    let placeOfOrigin: String?
    let provenanceText: String?
    
    func toSavedGallery() -> SavedGallery {
        return SavedGallery(
            id: id,
            imageId: imageId,
            creditLine: creditLine,
            desc: desc,
            shortDescription: shortDescription,
            publicationHistory: publicationHistory,
            exhibitionHistory: exhibitionHistory,
            artistTitle: artistTitle,
            placeOfOrigin: placeOfOrigin,
            provenanceText: provenanceText
        )
    }
}

@Model
class SavedGallery {
    @Attribute(.unique) var id: Int
    var imageId: String?
    var creditLine: String?
    var desc: String? = nil
    var shortDescription: String?
    var publicationHistory: String?
    var exhibitionHistory: String?
    var artistTitle: String?
    var placeOfOrigin: String?
    var provenanceText: String?
    
    init(id: Int, imageId: String? = nil, creditLine: String? = nil, desc: String? = nil, shortDescription: String? = nil, publicationHistory: String? = nil, exhibitionHistory: String? = nil, artistTitle: String? = nil, placeOfOrigin: String? = nil, provenanceText: String? = nil) {
        self.id = id
        self.imageId = imageId
        self.creditLine = creditLine
        self.desc = desc
        self.shortDescription = shortDescription
        self.publicationHistory = publicationHistory
        self.exhibitionHistory = exhibitionHistory
        self.artistTitle = artistTitle
        self.placeOfOrigin = placeOfOrigin
        self.provenanceText = provenanceText
    }
}

struct Pagination: Codable, Equatable {
    let total: Int
    let limit: Int
    let offset: Int
    let totalPages: Int
    let currentPage: Int
}
struct Config: Codable, Equatable {
  let iiifUrl: String
}
