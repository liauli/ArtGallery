//
//  GalleryModelTests.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 08/06/25.
//

import XCTest
@testable import ArtGallery

final class GalleryModelTests: XCTestCase {

    func test_toSavedGallery_mapsCorrectly() {
        // Given
        let gallery = Gallery(
            id: 1,
            imageId: "abc123",
            creditLine: "Credit",
            desc: "Desc",
            shortDescription: "Short",
            publicationHistory: "Pub",
            exhibitionHistory: "Exhibit",
            artistTitle: "Artist",
            placeOfOrigin: "Origin",
            provenanceText: "Provenance",
            title: "Title"
        )

        // When
        let saved = gallery.toSavedGallery()

        // Then
        XCTAssertEqual(saved.id, gallery.id)
        XCTAssertEqual(saved.imageId, gallery.imageId)
        XCTAssertEqual(saved.creditLine, gallery.creditLine)
        XCTAssertEqual(saved.desc, gallery.desc)
        XCTAssertEqual(saved.shortDescription, gallery.shortDescription)
        XCTAssertEqual(saved.publicationHistory, gallery.publicationHistory)
        XCTAssertEqual(saved.exhibitionHistory, gallery.exhibitionHistory)
        XCTAssertEqual(saved.artistTitle, gallery.artistTitle)
        XCTAssertEqual(saved.placeOfOrigin, gallery.placeOfOrigin)
        XCTAssertEqual(saved.provenanceText, gallery.provenanceText)
        XCTAssertEqual(saved.title, gallery.title)
    }

    func test_toGallery_mapsCorrectly() {
        // Given
        let saved = SavedGallery(
            id: 2,
            imageId: "img",
            creditLine: "Credit",
            desc: "Desc",
            shortDescription: "Short",
            publicationHistory: "Pub",
            exhibitionHistory: "Exhibit",
            artistTitle: "Artist",
            placeOfOrigin: "Origin",
            provenanceText: "Provenance",
            title: "Title"
        )

        // When
        let gallery = saved.toGallery()

        // Then
        XCTAssertEqual(gallery.id, saved.id)
        XCTAssertEqual(gallery.imageId, saved.imageId)
        XCTAssertEqual(gallery.creditLine, saved.creditLine)
        XCTAssertEqual(gallery.desc, saved.desc)
        XCTAssertEqual(gallery.shortDescription, saved.shortDescription)
        XCTAssertEqual(gallery.publicationHistory, saved.publicationHistory)
        XCTAssertEqual(gallery.exhibitionHistory, saved.exhibitionHistory)
        XCTAssertEqual(gallery.artistTitle, saved.artistTitle)
        XCTAssertEqual(gallery.placeOfOrigin, saved.placeOfOrigin)
        XCTAssertEqual(gallery.provenanceText, saved.provenanceText)
        XCTAssertEqual(gallery.title, saved.title)
    }
}
